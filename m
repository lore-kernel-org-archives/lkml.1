Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZHaPyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZHaPyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZHaPyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:54:37 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:37073 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZHaPyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v57BvB7zPtVTQhVkLcK+9eiA4HzGdNz5BSWl4xFMQ+qrwPbc+p6mdFQ21EKUXjFtAF
         Xuj09Fo2BFYw2hHYZ9ELLRmtq5M/IM0dFCsIaIw+7Nk1ha5yymoJArGaWe7lEjYAckYO
         PlgUGegNbDTjVR2TmUfIAjSaA/GMD/Ge5hBP0=
Date: Mon, 31 Aug 2009 23:58:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
Message-ID: <20090831155800.GA2937@hack>
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 08:30:08PM -0300, Luis Fernando Planella Gonzalez wrote:
>Hi.

Hi,

>I can't remember since when I've started seeing this, but since 2.6.23
>or 2.6.24, I think.
>Nowadays, I'm on Ubuntu 9.04, which is kernel 2.6.28.
>I'm flooded by the message: "do_IRQ: 0.91 No irq handler for vector"
>when in TTY.
>This is really annoying for text-base operation or in distros like
>sidux, where KDE watches syslog and shows a notification for every new
>line.
>Believe me, there are thousands of such notifications...
>Here is the dmesg results just after logging in:
>http://ubuntuforums.org/showpost.php?p=7759222&postcount=2 (yes, I've
>posted it in ubuntu forums with no succes ;)
>In this log, it's possible to see that the first time do_IRQ
>complains, it says: "do_IRQ: 0.99 No irq handler for vector". All
>others are for 0.91.
>I've tried adding the noirqbalance argument to kernel, and messed with
>everything related to IRQ in the BIOS with no success...
>Anybody, please help!!!

Hmm, I met a similar problem, on i386 2.6.29.

The more interesting thing is that the normal boot is fine but a kexec boot
will have this BUG_ON (about 50% chance), even 'irqpoll' doesn't help...

My guess is that maybe some driver failed to request_irq during kexec
boot, but I can't figure out which driver it is... Note, vector number
is 0x79.


-- 
Live like a child, think like the god.
 
