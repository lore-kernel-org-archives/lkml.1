Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYLKK2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYLKK2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbYLKK2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:28:45 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56543 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754630AbYLKK2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:28:44 -0500
X-Greylist: delayed 1338 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 05:28:44 EST
Date: Thu, 11 Dec 2008 11:06:16 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Alex Raimondi <mailinglist@miromico.ch>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: Segfault in fbcmap.c => Compiler bug?
Message-ID: <20081211110616.72f2d937@hskinnemoen-d830>
In-Reply-To: <4940CE1F.5080605@miromico.ch>
References: <4940CE1F.5080605@miromico.ch>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Raimondi wrote:
> 			if (transp) 
> 				htransp = *transp++;
> 
> 
> The segfault happens at the if (transp) statment.
> 
> Now to the strange thing, which makes me guess this may be a problem related to a compiler bug:
> 
> When I change the if statment to:
> 
> 			if (transp) {
> 				printk("e\n");
> 				htransp = *transp++;
> 			}

Yeah, as HC pointed out, this is caused by a buggy toolchain. Although
I don't have any disassembly to back it up, I'm willing to bet that it
will show an unconditional load followed by a conditional mov. The
printk() implies a barrier, which will prevent the faulty optimization
from happening.

Haavard
