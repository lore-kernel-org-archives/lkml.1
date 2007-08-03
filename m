Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXHCAMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXHCAMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 20:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758682AbXHCAMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 20:12:41 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33229 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556AbXHCAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 20:12:41 -0400
Date: Thu, 02 Aug 2007 17:18:10 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: REGRESSION: serial_cs broken by 8250 changes
In-reply-to: <20070802163547.39f41af1.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46B27442.7010706@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200708030106.33917.daniel.ritz-ml@swissonline.ch>
 <46B267BA.4030006@sun.com> <20070802163547.39f41af1.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 02 Aug 2007 16:24:42 -0700
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> Daniel Ritz wrote:
>>> commit 18a8bd949d6adb311ea816125ff65050df1f3f6e breaks serial_cs badly
>>> with an oops, completely killing PCMCIA.
>>>
>>> register_console() now calls console->early_setup(). which in case of
>>> 8250.c (the only user anyway) is serial8250_console_early_setup()
>>> which is __init, calling 8250_early.c:serial8250_find_port_for_earlycon()
>>> which is __init as well. boom.
>>>
>>> the changelog mentions SERIAL_PORT_DFNS removal which happens to be
>>> commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26. but this got reverted
>>> by commit 57d4810ea0d9ca58a7bcc1336607f0cede0a2abf. so i'd suggest to
>>> just revert the 8250 changes as well.
>>>
>>> rgds
>>> -daniel
>> Is there any flag or sign that init code has been released?
> 
> Nope.
> 
>> We could use that to prevent init code to be called after code is freed.
> 
> If we can omit a function call without breaking anything then we shouldn't
> have been calling that function at all ;)
> 
> It sounds like making serial8250_console_early_setup() and
> serial8250_find_port_for_earlycon() non-__init will fix this.
> 

yes, together update_console_cmdline in kernel/printk.c

Daniel,
can you test that in your setup?

Thanks

Yinghai Lu
