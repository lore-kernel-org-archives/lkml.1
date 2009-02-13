Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZBMJYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZBMJYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZBMJYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:24:21 -0500
Received: from www.tglx.de ([62.245.132.106]:57149 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZBMJYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:24:20 -0500
Date: Fri, 13 Feb 2009 10:23:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can request_irq be called under spinlock?
In-Reply-To: <4994B23D.4040806@goop.org>
Message-ID: <alpine.LFD.2.00.0902131022220.16972@localhost.localdomain>
References: <499481B9.4090202@goop.org> <alpine.LFD.2.00.0902122326100.16972@localhost.localdomain> <4994B23D.4040806@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Jeremy Fitzhardinge wrote:
> Thomas Gleixner wrote:
> > I dont think that proc_mkdir conventions have changed
> > recently. According to git blame fs/proc/generic.c:
> > 
> > ^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700 580)     ent =
> > kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
> > 
> >   
> 
> I think its new that request_irq ends up calling proc_mkdir though.  But its
> moot now anyway; I cleaned up that code, and don't call request_irq under
> spinlock any more.

Just checked. The register_irq_proc() and register_handler_proc()
calls in request/setup_irq() have the same time stamp in git :)

Thanks,

	tglx
