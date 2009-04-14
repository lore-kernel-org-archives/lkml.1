Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZDNNg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZDNNg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZDNNgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:36:49 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35435 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZDNNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=SqNtgjLW2zxHkzeMXKMjoAMT/sqFh4z0vSNzY7Vt6cXels3yRQS2dB/wCHbz5Wi1Tc
         bnJ59g+f47bEOjEEOAkdgqifqX7jg6s/n0YrnxuQT7+O8n9V8JwmnLn6c7Pjywl86htU
         PaHJLoTjO3V5ksV8lksLPb8Ook/6aq1ByNHHk=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
Date: Tue, 14 Apr 2009 14:36:46 +0100
Message-ID: <9b2b86520904140636x1971b44g898c29e8b0904396@mail.gmail.com>
Subject: Re: Fast testing
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/09, Dragoslav Zaric <dragoslav.zaric.kd@gmail.com> wrote:
> Hello,
>
> I have question regarding fast testing of some change in some kernel
> source file. Since rebooting is a long process, there must be way to
> test some change faster [of course only if source file is not some boot
> connected file, but maybe this is also doable].
>
> This is question:
>
> When system is running, file that drives the system is "vmlinux" executable
> and it is located in "/" or "/boot" folder.

Nope.

Kernel code (and data) is not demand-paged.  The kernel image is fully
loaded into memory at boot-time.  Changing /boot/vmlinuz will have no
effect on the running kernel.  And there are several other reasons why
what you describe would not work.

What you can do is compile some code as a module, and remove and
re-insert it to apply changes.  This doesn't work for core code or
your main disk driver though :-).

Alan
