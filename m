Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYLOX1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYLOX1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYLOX1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:27:37 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:26409 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYLOX1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:27:37 -0500
Message-ID: <4946E7DC.7010403@oracle.com>
Date: Mon, 15 Dec 2008 15:27:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: linux-next: Tree for December 15 (MTD)
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
In-Reply-To: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4946E7D1.00BB:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081212:
> 
> New tree:
> 	boot-params
> 
> Undropped tree:
> 	mtd


On i386 builds, I'm seeing

build-r7137.out:mtd_dataflash.c:(.text+0x10dff4): undefined reference to `__umoddi3'
build-r7137.out:mtd_dataflash.c:(.text+0x10e010): undefined reference to `__umoddi3'
build-r7137.out:mtd_dataflash.c:(.text+0x10e09f): undefined reference to `__udivdi3'

which are caused by % and / operations where the denominator is a variable:

	/* Sanity checks */
	if ((instr->addr + instr->len) > mtd->size
			|| (instr->len % priv->page_size) != 0
			|| (instr->addr % priv->page_size) != 0)
		return -EINVAL;

...
		/* Calculate flash page address; use block erase (for speed) if
		 * we're at a block boundary and need to erase the whole block.
		 */
		pageaddr = instr->addr / priv->page_size;


~Randy


