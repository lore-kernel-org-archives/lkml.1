Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZFDMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZFDMEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZFDME3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:04:29 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:33883 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZFDME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:04:28 -0400
Date: Thu, 4 Jun 2009 13:04:23 +0100 (WEST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Roel Kluin <roel.kluin@gmail.com>
cc: davem@davemloft.net, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] serial: off by one
In-Reply-To: <4A270541.4050900@gmail.com>
Message-ID: <alpine.LFD.1.10.0906041303510.332@ftp.linux-mips.org>
References: <4A270541.4050900@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Roel Kluin wrote:

> In zs_console_putchar() occurs:
> 
> 	if (zs_transmit_drain(zport, irq))
> 		write_zsdata(zport, ch);
> 
> However if in zs_transmit_drain() no empty Tx Buffer occurs, limit reaches
> -1 => true, and the write still occurs.
> 
> This patch changes postfix to prefix decrements in this and similar
> functions to prevent similar mistakes in the future. This decreases the
> iterations with one but the chosen loop count was arbitrary anyway.
> 
> In sunhv limit reaches -1, not 0, so the test is off by one.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

  Maciej
