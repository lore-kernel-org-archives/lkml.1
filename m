Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbXLMNDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbXLMNDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXLMNCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:02:55 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:57425 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505AbXLMNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:02:54 -0500
Date: Thu, 13 Dec 2007 18:32:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213130231.GB16905@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071212134158.GA5547@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071213114336.GA5400@linux.vnet.ibm.com> <20071213125509.GA28340@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213125509.GA28340@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 01:55:09PM +0100, Ingo Molnar wrote:
> 
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > Could you please see if the following patch removes the oops due to 
> > CFS sysfs files? (There might still be the other oops due to the 
> > floppy sysfs files)
> > 
> > Ingo, could you please add this patch in your CFS backport to 2.6.22 
> > and older kernels?
> 
> sure - i've updated the backport patches with this fix.
> 

Thanks!

> >  static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
> >  {
> > +	sa->attr.owner = NULL;
> >  	sa->attr.name = name;
> 
> i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs 
> initialize the owner field to NULL automatically?
> 

Going through git log, it seems that commit
7b595756ec1f49e0049a9e01a1298d53a7faaa15 deemed attribute->owner as
unnecessary. I guess that answers the question.

-- 
regards,
Dhaval
