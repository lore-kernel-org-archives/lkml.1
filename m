Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377Ab0AHKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0AHKJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891Ab0AHKJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:09:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52246 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0AHKJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rsWBAyQDLTVMeE9oDoWY7SOryY2reoorfIQEelGEX/HlLHImXkbDNyQF2YEyIcVBtk
         iV0c38hnudrM3riQ6pVULz62YfgVJtU1J+QYkERQxkSJVQ+6SHdVlyelGF3P1by6EOVG
         y7CQ9BNPGbQUd6P0R+JGyA7P6c5LKd4agAJJs=
MIME-Version: 1.0
In-Reply-To: <20100108094627.GA17598@sortiz.org>
References: <1262905725-4178-1-git-send-email-linus.walleij@stericsson.com>
	 <20100108093303.GA3734@sortiz.org> <20100108094627.GA17598@sortiz.org>
Date: Fri, 8 Jan 2010 11:09:31 +0100
Message-ID: <63386a3d1001080209q51cf62f8tfbe7c2062e1657f3@mail.gmail.com>
Subject: Re: [PATCH] Convert the AB3100 driver to use threaded IRH
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/8 Samuel Ortiz <sameo@linux.intel.com>:

> Linus, I fogot to mention that I removed IRQF_SAMPLE_RANDOM from your
> request_threaded_irq() arguments, as it is scheduled for removal. See
> Documentation/feature-removal-schedule.txt.
> Please let me know if that's a problem for you.

I got the warning from checkpatch as well, and since this is an
interrupt source which is truly random and we really *want* to sample
for some IRQ randomness I do want that functionality in there.

However the fucntions to be used instead,
rand_initialize_irq() + add_interrupt_randomness() aren't used
anywhere else in the kernel than in the interrupt driver core.

But I don't mind being first ... if you upload your git tree to
git.kernel.org I'll make a patch to reenable this the right way.
(Or I can rewrite the previous patch, your choice.)

Linus
