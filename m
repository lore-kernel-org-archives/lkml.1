Return-Path: <linux-kernel-owner+w=401wt.eu-S1765090AbYBZUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765090AbYBZUpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYBZUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:45:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52628
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755980AbYBZUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:45:26 -0500
Date: Tue, 26 Feb 2008 12:46:11 -0800 (PST)
Message-Id: <20080226.124611.206089131.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18371.10207.58819.188510@alkaid.it.uu.se>
References: <18371.10207.58819.188510@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 25 Feb 2008 21:41:03 +0100

> Another difference is that with rc2 the first few lines of kernel
> output while the console is still in OF mode either aren't shown
> or disappear quickly since the switch to the framebuffer occurs
> within a fraction of a second after the kernel has been loaded.
> With rc3 the kernel output (the text shown above) in the OF-mode
> console is very very slow.

Yes that's a new feature.  Until we switch over to the "real"
console we print the log messages using the firmware console
routines.

This way if an early crash or similar happens, you'll see it
and be able to report it instead of having to report with
"-p" on the command line.

I'll fire up my ultra5 and try to figure out what's wrong
with the atyfb framebuffer driver, that's where it's dying.
