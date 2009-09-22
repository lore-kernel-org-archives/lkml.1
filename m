Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZIVX1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZIVX1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZIVX1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:27:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbZIVX1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:27:32 -0400
Date: Tue, 22 Sep 2009 16:25:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: dbrownell@users.sourceforge.net, dwmw2@infradead.org, dedekind1@gmail.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] mtd: m25p80: Add support for CAT25xxx serial
 EEPROMs
Message-Id: <20090922162548.3e20e67c.akpm@linux-foundation.org>
In-Reply-To: <20090818214628.GB22651@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
	<20090818214628.GB22651@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 01:46:28 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> CAT25 chips (as manufactured by On Semiconductor, previously Catalyst
> Semiconductor) are similar to the original M25Px0 chips, except:
> 
> - Address width can vary (1-2 bytes, in contrast to 3 bytes in M25P
>   chips). So, implement convenient m25p_addr2cmd() and m25p_cmdsz()
>   calls, and place address width information into flash_info struct;
> 
> - Page size can vary, therefore we shouldn't hardcode it, so get rid
>   of FLASH_PAGESIZE definition, and place the page size information
>   into flash_info struct;
> 
> - CAT25 EEPROMs don't need to be erased, so add NO_ERASE flag, and
>   propagate it to the mtd subsystem.

This patch (still) doesn't know about the mx25l3205d, mx25l12805d and
mx25l12855e devices.

I randomly did this:

->	{ "mx25l3205d", INFO(0xc22016, 0, 64 * 1024, 64, 256, 3, 0) },
->	{ "mx25l6405d", INFO(0xc22017, 0, 64 * 1024, 128, 256, 3, 0) },
	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 256, 3, 0) },
->	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 256, 3, 0) },

