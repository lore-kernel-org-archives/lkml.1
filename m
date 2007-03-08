Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbXCHFU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbXCHFU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXCHFUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:20:25 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44253 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXCHFUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:20:24 -0500
Date: Thu, 8 Mar 2007 10:47:30 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 16/20] swsusp: do not use virt_to_page on kernel data address
Message-ID: <20070308051730.GH6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <20070307072008.GQ23412@in.ibm.com> <20070307224915.GG5956@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307224915.GG5956@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:49:15PM +0100, Pavel Machek wrote:
> Hi!
> 
> > o virt_to_page() call should be used on kernel linear addresses and not
> >   on kernel text and data addresses. Swsusp code uses it on kernel data
> >   (statically allocated swsusp_header).
> > 
> > o Allocate swsusp_header dynamically so that virt_to_page() can be used
> >   safely.
> > 
> > o I am changing this because in next few patches, __pa() on x86_64 will
> >   no longer support kernel text and data addresses and hibernation breaks. 
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> 
> > +static int swsusp_header_init(void)
> > +{
> > +	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
> > +	if (!swsusp_header)
> > +		panic("Could not allocate memory for swsusp_header\n");
> > +	return 0;
> > +}
> > +
> > +core_initcall(swsusp_header_init);
> 
> I do not like the panic, but I guess it is okay as we are running
> during boot? (Could you add a comment?) Otherwise ok.
> 

Hi Pavel,

Yes, it is an initcall and this memory page will be allocated during
boot time. Not very sure what comment to put there. To me it seems
pretty obivious with "core_initcall".

Thanks
Vivek
