Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbZBLXfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbZBLXfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBLXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:35:28 -0500
Received: from gw.goop.org ([64.81.55.164]:39548 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZBLXf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:35:28 -0500
Message-ID: <4994B23D.4040806@goop.org>
Date: Thu, 12 Feb 2009 15:35:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can request_irq be called under spinlock?
References: <499481B9.4090202@goop.org> <alpine.LFD.2.00.0902122326100.16972@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902122326100.16972@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> I dont think that proc_mkdir conventions have changed
> recently. According to git blame fs/proc/generic.c:
>
> ^1da177e (Linus Torvalds     2005-04-16 15:20:36 -0700 580)     ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
>
>   

I think its new that request_irq ends up calling proc_mkdir though.  But 
its moot now anyway; I cleaned up that code, and don't call request_irq 
under spinlock any more.

    J
