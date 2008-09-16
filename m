Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYIPSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYIPSKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYIPSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:10:34 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42830 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbYIPSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Nedht4vH6fMqUk9n72op43G47fXlfJbOcuW5HipSuOmy2u0Mr4lPCbkbRtIj6iOs3O
         zZ/iAh7kyKcW1KxFjQK9w2ldK0oekLB8de+mhtpFww0lynV8HE2xZpqEb0RwfRzkZ/3D
         4Nr9ByxntXKA6Icg6eRr7ml5Ty8B8OP069QWM=
Message-ID: <86802c440809161110q1fc3d66vedcaa32dea2b2233@mail.gmail.com>
Date: Tue, 16 Sep 2008 11:10:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] introduce boot_printk()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jbaron <jbaron@redhat.com>
In-Reply-To: <48CFF281.7010101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <48CE983C.8040709@zytor.com>
	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
	 <48CE9A5C.1030603@zytor.com>
	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>
	 <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>
	 <48CFD97C.6080002@zytor.com>
	 <86802c440809161045q2f6d80f1yb6e79f32c6e0c303@mail.gmail.com>
	 <48CFF281.7010101@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> it seem using pci_printk or acpi_printk.. could be more flexible.
>>
>> otherwise will need to keep update linux/kernel.h to add so call subsys
>> tags...
>>
>> use only need to
>> have DEFINE_LOGLEVEL_SETUP(xxx) in c
>> and have DECLARE_LOGLEVEL(xxx) in .h
>> then just use xxx_printk
>>
>
> Uh?  You can add the subsys tags elsewhere if you prefer too.
>
> However, there are a few important differences to keep in mind.  Tags get
> logged in the dmesg buffer even if not printed to the kernel, whereas a
> jump-based architecture will not just suppress the output, but even the
> formatting of the output.  Either is a good thing for certain things, and a
> bad thing for other things.
>
> I personally think the kind of things discussed belong in the category of
> "always put in the dmesg buffer", and like the idea of subsystem-tagging
> them.
>

you still can use
pci_printk(v, KERN_PCI KERN_DEBUG "...\n");

if vprintk is expanded to handle KERN_PCI and other tags...
or even you could use
pci_printk(v, KERN_ACPI KERN_DEBUG "...\n");

YH
