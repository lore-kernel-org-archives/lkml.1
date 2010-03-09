Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0CIVWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:22:05 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44130 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0CIVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:22:01 -0500
Date: Tue, 9 Mar 2010 22:22:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] memory hotplug/s390: set phys_device
Message-ID: <20100309212211.GA2288@osiris.boeblingen.de.ibm.com>
References: <20100309172052.GC2360@osiris.boeblingen.de.ibm.com>
 <20100309123748.3015e10a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309123748.3015e10a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:37:48PM -0800, Andrew Morton wrote:
> On Tue, 9 Mar 2010 18:20:52 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > Implement arch specific arch_get_memory_phys_device function and initialize
> > phys_device for each memory section. That way we finally can tell which
> > piece of memory belongs to which physical device.
> > 
> > --- a/drivers/s390/char/sclp_cmd.c
> > +++ b/drivers/s390/char/sclp_cmd.c
> > @@ -704,6 +704,13 @@ int sclp_chp_deconfigure(struct chp_id c
> >  	return do_chp_configure(SCLP_CMDW_DECONFIGURE_CHPATH | chpid.id << 8);
> >  }
> >  
> > +int arch_get_memory_phys_device(unsigned long start_pfn)
> > +{
> > +	if (!rzm)
> > +		return 0;
> > +	return PFN_PHYS(start_pfn) / rzm;
> > +}
> > +
> >  struct chp_info_sccb {
> >  	struct sccb_header header;
> >  	u8 recognized[SCLP_CHP_INFO_MASK_SIZE];
> 
> What is the utility of this patch?  It makes s390's
> /sys/devices/system/memory/memoryX/phys_device display the correct
> thing?

Yes, exactly.
