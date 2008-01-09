Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYAIKMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYAIKMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYAIKMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:12:39 -0500
Received: from twin.jikos.cz ([213.151.79.26]:60625 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYAIKMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:12:37 -0500
Date: Wed, 9 Jan 2008 11:11:53 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dtor@mail.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org
Subject: Re: evdev soft lockup 2.6.24-rc5-mm1
In-Reply-To: <47848CF5.8000107@gmail.com>
Message-ID: <Pine.LNX.4.64.0801091107200.25041@twin.jikos.cz>
References: <47848CF5.8000107@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Jiri Slaby wrote:

> BUG: soft lockup - CPU#1 stuck for 11s! [X:2887]
[ ... ]
> Call Trace:
>  [<ffffffff804e7648>] __mutex_lock_slowpath+0x38/0xd0
>  [<ffffffff804e747e>] mutex_lock+0x1e/0x30
>  [<ffffffff8040c497>] input_release_device+0x27/0x50
>  [<ffffffff804102aa>] evdev_ungrab+0x3a/0x50
>  [<ffffffff804103eb>] evdev_release+0xcb/0xd0
>  [<ffffffff80293460>] __fput+0xc0/0x230
>  [<ffffffff802938a6>] fput+0x16/0x20
>  [<ffffffff80290296>] filp_close+0x56/0x90
>  [<ffffffff80291afa>] sys_close+0x9a/0xf0
>  [<ffffffff8020ba4e>] system_call+0x7e/0x83
> I was not able to use sysrq keys, the keyboard is obviously defunct. If 
> this is not known, I'll try to turn lockdep on and maybe connect through 
> ssh next time it happens.

Is this reproducible on your side? 

Running with lockdep would be really helpful, so that we possibly know who 
is holding the other instance of dev->mutex.

-- 
Jiri Kosina
