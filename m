Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbXLCLam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbXLCLam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXLCLae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:30:34 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:30165 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbXLCLad convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:30:33 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure (v2)
Date: Mon, 3 Dec 2007 17:00:23 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Avi Kivity <avi@qumranet.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org
References: <11898788932902-git-send-email-aliguori@us.ibm.com> <200712031416.51710.amit.shah@qumranet.com> <4753C59A.4030206@qumranet.com>
In-Reply-To: <4753C59A.4030206@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712031700.24084.amit.shah@qumranet.com>
X-OriginalArrivalTime: 03 Dec 2007 11:30:32.0409 (UTC) FILETIME=[EA1FE490:01C8359F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity wrote:
> Amit Shah wrote:
> > * Anthony Liguori wrote:
> >  
> >
> >> Amit Shah wrote:
> >>    
> >>
> >> What are you using to issue the hypercall?
> >>    
> >
> > +       r = kvm_hypercall1(KVM_PV_PCI_DEVICE, page_gfn);
> >
> > Setup is done by:
> >
> > +       if (!kvm_para_available()) {
> > +               printk(KERN_ERR "KVM paravirt support not available\n");
> > +               r = -ENODEV;
> > +               goto out_dereg;
> > +       }
> >  
>
> There was a bug where instructions with a modrm byte specifying a
> register would try to access memory.  In the memory was not mapped,  
> emulation would fail. vmcall is one such instruction.  This was fixed by
>
> commit f83562246921d6a8a7de8b76853a6835ace3699d
> Author: Aurelien Jarno <aurelien@aurel32.net>
> Date:   Wed Oct 17 19:30:41 2007 +0200
>
>     KVM: x86 emulator: fix access registers for instructions with ModR/M
> byte and Mod = 3

Thanks, and thank you, Aurelien!
