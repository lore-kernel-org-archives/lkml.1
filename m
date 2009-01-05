Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZAEGmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZAEGmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 01:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZAEGmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 01:42:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44005
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbZAEGmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 01:42:39 -0500
Date: Sun, 04 Jan 2009 22:42:39 -0800 (PST)
Message-Id: <20090104.224239.64637126.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix SONIC_READ definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <495FB1CC.5090506@gmail.com>
References: <495FB1CC.5090506@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sat, 03 Jan 2009 19:43:24 +0100

> drivers/net/jazzsonic.c:56:
> #define SONIC_READ(reg) (*((volatile unsigned int *)dev->base_addr+reg))
> 
> drivers/net/sonic.h:53:
> #define SONIC_CAP0             0x24
> 
> so drivers/net/jazzsonic.c:143:
> val = SONIC_READ(SONIC_CAP0-i);
> 
> becomes
> 
> val = (*((volatile unsigned int *)dev->base_addr+0x24-i));
> 
> That is wrong, isn't it?

The expression, both with and without the parentheses around "reg",
evaluate to the same final pointer value.

Compile a test program and look at the assembler output if you
don't believe me :-)
