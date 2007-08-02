Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbXHBUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbXHBUP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbXHBUPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:15:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:47036 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757469AbXHBUPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:15:12 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+r/5dEBV6re2NvtJkarArsMx6SMbouUQkGqbbWYJ
	E7XMfZRCOW6BQP
Date: Thu, 2 Aug 2007 22:15:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <9a8748490708021303h683a8be7if194a9314483c218@mail.gmail.com>
Message-ID: <Pine.LNX.4.60.0708022211470.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> 
 <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
 <9a8748490708021303h683a8be7if194a9314483c218@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Jesper Juhl wrote:

> I believe Guennadi's point is that gcc does not warn about it in the
> case of  c[4] = "0123"; but only in the case of c[4] = "01234" - so if
> we do have such initializations in the kernel we may have some bugs
> hiding there that gcc doesn't warn us about.

Exactly. Think of all structs with fixed-length char arrays (various 
device name fields, etc.) static instances of which re scattered across 
all possible drivers... Usually those strings should be long "enough", but 
if someone manages to exactly hit the length, there won't be a warning.

Thanks
Guennadi
---
Guennadi Liakhovetski
