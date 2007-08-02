Return-Path: <linux-kernel-owner+w=401wt.eu-S1761847AbXHBXT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761847AbXHBXT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbXHBXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:19:22 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63519 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbXHBXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:19:21 -0400
Date: Thu, 02 Aug 2007 16:24:42 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: REGRESSION: serial_cs broken by 8250 changes
In-reply-to: <200708030106.33917.daniel.ritz-ml@swissonline.ch>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46B267BA.4030006@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <200708030106.33917.daniel.ritz-ml@swissonline.ch>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Ritz wrote:
> commit 18a8bd949d6adb311ea816125ff65050df1f3f6e breaks serial_cs badly
> with an oops, completely killing PCMCIA.
> 
> register_console() now calls console->early_setup(). which in case of
> 8250.c (the only user anyway) is serial8250_console_early_setup()
> which is __init, calling 8250_early.c:serial8250_find_port_for_earlycon()
> which is __init as well. boom.
> 
> the changelog mentions SERIAL_PORT_DFNS removal which happens to be
> commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26. but this got reverted
> by commit 57d4810ea0d9ca58a7bcc1336607f0cede0a2abf. so i'd suggest to
> just revert the 8250 changes as well.
> 
> rgds
> -daniel

Is there any flag or sign that init code has been released?

We could use that to prevent init code to be called after code is freed.

Thanks

Yinghai Lu
