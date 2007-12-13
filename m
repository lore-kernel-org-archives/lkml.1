Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXLMOBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXLMOBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbXLMOBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:01:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbXLMOBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:01:22 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <20071213125509.GA28340@elte.hu>
References: <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071211182015.GA22339@linux.vnet.ibm.com>
	 <20071211182528.GA5597@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071212134158.GA5547@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071213114336.GA5400@linux.vnet.ibm.com> <20071213125509.GA28340@elte.hu>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 14:59:57 +0100
Message-Id: <1197554397.19869.3.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18slasG8VFRqmW9zxCK2UZQr2XZaapcmP5pYA7
 ZwVALzg4zDhgVjU+SI65TTRIsU6ljs1KmWDKpECuumwRFzSUoU
 lVxr/GdBMwtBEV/1WKtCQHURz7C2G44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 13:55 +0100, Ingo Molnar wrote:
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
> >  static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
> >  {
> > +	sa->attr.owner = NULL;
> >  	sa->attr.name = name;
> 
> i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs 
> initialize the owner field to NULL automatically?

Attibutes do not have an owner anymore:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b595756ec1f49e0049a9e01a1298d53a7faaa15

Kay

