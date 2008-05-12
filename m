Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYELVDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYELVDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYELVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:03:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48747
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755461AbYELVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:03:23 -0400
Date: Mon, 12 May 2008 14:03:17 -0700 (PDT)
Message-Id: <20080512.140317.133389925.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18472.38209.615770.265421@alkaid.it.uu.se>
References: <18465.63175.561233.228014@alkaid.it.uu.se>
	<20080512.005036.19633770.davem@davemloft.net>
	<18472.38209.615770.265421@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 12 May 2008 21:06:41 +0200

> David Miller writes:
>  > We have some existing debugging, which I'd like you to enable on the
>  > boot command line.  Simply add "numa=debug" and that'll get some more
>  > vebose information.
>  > 
>  > Please also add the debugging patch below.
> 
> Right, 2.6.26-rc2 plus your debugging patch and booted with numa=debug
> prints the following:

Thanks, I'll look over this!

> One thing that bothers me is the "Memory hole size: 128MB" message.
> It wasn't present in 2.6.25, and the amount reported is the exact
> same amount of RAM I've lost. Or maybe I'm paranoid :-)

It's completely new and harmless.  You have memory at 0->128MB and
at 256MB->384MB.  That gap from 128MB->256MB is the hole is it talking
about.

It's computed very simply, it is the difference between the highest
value physical address of available memory and the total amount of
available memory.

Don't let it scare you, it's 2GB on one of my machines :-)
