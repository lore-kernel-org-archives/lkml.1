Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXHBXgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXHBXgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXHBXg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:36:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36747 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbXHBXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:36:26 -0400
Date: Thu, 2 Aug 2007 16:35:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai.Lu@Sun.COM
Cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: serial_cs broken by 8250 changes
Message-Id: <20070802163547.39f41af1.akpm@linux-foundation.org>
In-Reply-To: <46B267BA.4030006@sun.com>
References: <200708030106.33917.daniel.ritz-ml@swissonline.ch>
	<46B267BA.4030006@sun.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 16:24:42 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> Daniel Ritz wrote:
> > commit 18a8bd949d6adb311ea816125ff65050df1f3f6e breaks serial_cs badly
> > with an oops, completely killing PCMCIA.
> > 
> > register_console() now calls console->early_setup(). which in case of
> > 8250.c (the only user anyway) is serial8250_console_early_setup()
> > which is __init, calling 8250_early.c:serial8250_find_port_for_earlycon()
> > which is __init as well. boom.
> > 
> > the changelog mentions SERIAL_PORT_DFNS removal which happens to be
> > commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26. but this got reverted
> > by commit 57d4810ea0d9ca58a7bcc1336607f0cede0a2abf. so i'd suggest to
> > just revert the 8250 changes as well.
> > 
> > rgds
> > -daniel
> 
> Is there any flag or sign that init code has been released?

Nope.

> We could use that to prevent init code to be called after code is freed.

If we can omit a function call without breaking anything then we shouldn't
have been calling that function at all ;)

It sounds like making serial8250_console_early_setup() and
serial8250_find_port_for_earlycon() non-__init will fix this.

