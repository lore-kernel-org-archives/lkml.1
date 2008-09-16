Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYIPRyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYIPRyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYIPRya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:54:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYIPRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:54:29 -0400
Message-ID: <48CFF281.7010101@zytor.com>
Date: Tue, 16 Sep 2008 10:53:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbaron <jbaron@redhat.com>
Subject: Re: [PATCH] introduce boot_printk()
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>	 <48CE983C.8040709@zytor.com>	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>	 <48CE9A5C.1030603@zytor.com>	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>	 <48CFD97C.6080002@zytor.com> <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>
In-Reply-To: <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> it seem using pci_printk or acpi_printk.. could be more flexible.
> 
> otherwise will need to keep update linux/kernel.h to add so call subsys tags...
> 
> use only need to
> have DEFINE_LOGLEVEL_SETUP(xxx) in c
> and have DECLARE_LOGLEVEL(xxx) in .h
> then just use xxx_printk
> 

Uh?  You can add the subsys tags elsewhere if you prefer too.

However, there are a few important differences to keep in mind.  Tags 
get logged in the dmesg buffer even if not printed to the kernel, 
whereas a jump-based architecture will not just suppress the output, but 
even the formatting of the output.  Either is a good thing for certain 
things, and a bad thing for other things.

I personally think the kind of things discussed belong in the category 
of "always put in the dmesg buffer", and like the idea of 
subsystem-tagging them.

	-hpa
