Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbYG3EiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbYG3EiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYG3Ehw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:37:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbYG3Ehv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:37:51 -0400
Date: Tue, 29 Jul 2008 21:37:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       Bryan Wu <cooloney@kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND x2 PATCH 2.6.26-git 1/2] MTD DataFlash: bugfix, binary
 page sizes now handled (v3)
Message-Id: <20080729213733.3345546a.akpm@linux-foundation.org>
In-Reply-To: <200807270325.13790.david-b@pacbell.net>
References: <200807270325.13790.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008 03:25:13 -0700 David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> The wrong version of the "teach dataflash about binary density" patch
> just got merged (v2 not v3) ... this restores the missing updates:
> 
>   * Fix the cmdlinepart *regression* that caused testing failures (!!)
>     by restoring the original part labels in relevant cases.
> 
>   * Don't reference things that don't exist (!)
> 	- An opcode that doesn't even exist for DataFlash
> 	- The part is "at45db642" not "at45db641"
> 	- ID zero in this JEDEC table
> 
>   * Make the JEDEC probe routine report and handle errors better:
> 	- If the SPI calls fail, return the error codes.
> 	- Don't depend on ordering of table entries.
> 	- Unrecognized ids are different from parts that have no ID.
>           We won't actually know how to handle them correctly; display
> 	  the ID and ignore the chip.
> 
>   * Move the original block comment about the "legacy" chip ID scheme
>     back next to the code to which it applies ... not next to the new
>     JEDEC query code, which uses an entirely different strategy.
> 
>   * Don't print a guessed erasesize; /proc/mtd has the real value.
> 
> And add a few more comments.
> 

drivers/mtd/devices/mtd_dataflash.c: In function 'jedec_probe':
drivers/mtd/devices/mtd_dataflash.c:611: error: incompatible type for argument 1 of 'dev_name'
drivers/mtd/devices/mtd_dataflash.c:619: error: incompatible type for argument 1 of 'dev_name'

