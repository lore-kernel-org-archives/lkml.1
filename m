Return-Path: <linux-kernel-owner+w=401wt.eu-S934801AbYBNA0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbYBNA0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934515AbYBNAW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:22:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60754 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934502AbYBNAWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:24 -0500
Date: Thu, 14 Feb 2008 00:14:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ricardo J. =?UTF-8?B?Um9kcsOtZ3Vleg==?=" <ricardo.rdez@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Semaphores with timeouts
Message-ID: <20080214001454.4e8cb0eb@core>
In-Reply-To: <9a8e2be0802131608m7eef61efmaee332a661503f39@mail.gmail.com>
References: <9a8e2be0802131608m7eef61efmaee332a661503f39@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 01:08:28 +0100
"Ricardo J. Rodríguez" <ricardo.rdez@gmail.com> wrote:

> Hi everybody,
> I'm developing a driver to support a new protocol on the kernel 2.6.x,
> a real time communication protocol used in robotic fields. Skipping
> the intro: I need to know if there is any function in the kernel to
> get the process sleeping, as down_interruptible(...), but with
> timeouts, I mean, I want the process to wake up if no signal is
> detected in a while...

The Unix world normally expects rather different behaviour

With O_NDELAY set -> no delay but -EAGAIN
Normal -> delay until error or completes or EOF

and the use of poll/select to wait until the event can be issued and is
going to complete. Hence the lack of a mutex_lock_interruptible_timeout()


It's certainly possible to add one but the first question would be "why
do you need it - what sort of API are you trying to build"

Alan
