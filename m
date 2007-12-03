Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXLCIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXLCIrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXLCIrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:47:04 -0500
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:58476 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbXLCIrD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:47:03 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure (v2)
Date: Mon, 3 Dec 2007 14:16:51 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
References: <11898788932902-git-send-email-aliguori@us.ibm.com> <200712021917.28706.amit.shah@qumranet.com> <475339A6.9020207@us.ibm.com>
In-Reply-To: <475339A6.9020207@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712031416.51710.amit.shah@qumranet.com>
X-OriginalArrivalTime: 03 Dec 2007 08:47:00.0878 (UTC) FILETIME=[11FF12E0:01C83589]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori wrote:
> Amit Shah wrote:
> > * Anthony Liguori wrote:
> >  
> >
> >> This patch refactors the current hypercall infrastructure to better
> >> support live migration and SMP.  It eliminates the hypercall page by
> >> trapping the UD exception that would occur if you used the wrong
> >> hypercall instruction for the underlying architecture and replacing it
> >> with the right one lazily. 
> >
> > This doesn't work right for SVM. It keeps looping indefinitely; on a
> > kvm_stat run, I get about 230,000 light vm exits per second, with the
> > hypercall never returning to the guest.
> >
> > ...
> >  
>
> What are you using to issue the hypercall?

+       r = kvm_hypercall1(KVM_PV_PCI_DEVICE, page_gfn);

Setup is done by:

+       if (!kvm_para_available()) {
+               printk(KERN_ERR "KVM paravirt support not available\n");
+               r = -ENODEV;
+               goto out_dereg;
+       }

I also couldn't get the has_feature to work properly.

See:

http://lkml.org/lkml/2007/11/7/129

I had to change the hypercall address to 0f 01 d9 for it to get working.

>
> Regards,
>
> Anthony Liguori


