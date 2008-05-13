Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYEMVJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYEMVJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbYEMVJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:09:28 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:53175 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108AbYEMVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:09:27 -0400
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86: janitor work in bugs.c
From: Andi Kleen <andi@firstfloor.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
	<fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
Date: Tue, 13 May 2008 23:09:24 +0200
In-Reply-To: <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org> (Miklos Vajna's message of "Tue, 13 May 2008 13:35:26 +0200")
Message-ID: <87tzh17vy3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 21:02:25.0170 (UTC) FILETIME=[A50B3720:01C8B53C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Vajna <vmiklos@frugalware.org> writes:
>  	if (!boot_cpu_data.hard_math) {
>  #ifndef CONFIG_MATH_EMULATION
> -		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
> +		printk(KERN_EMERG "No coprocessor found and no math "
> +			"emulation present.\n");

This means if someone gets this message and wants to grep for it they won't
find it. Bad bad bad.

We had a discussion recently that wrapping printk format strings
is a bad idea. Don't do it please.

-Andi
