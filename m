Return-Path: <linux-kernel-owner+w=401wt.eu-S935396AbYBNBM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935396AbYBNBM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935106AbYBNBKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:10:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49750 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935181AbYBNBKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:10:50 -0500
Date: Wed, 13 Feb 2008 17:09:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging
 printk, take #3
Message-Id: <20080213170950.86945835.akpm@linux-foundation.org>
In-Reply-To: <47B38E13.1060503@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
	<20080213155701.48871761.akpm@linux-foundation.org>
	<47B38E13.1060503@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 09:40:51 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Can you please take a look at ata_eh_link_report() in
> drivers/ata/libata-eh.c?

I did.  Punishment?

>  Currently, it has some problems.

Yes, and the patches do clean that up.

ho hum.  What tends to happen with this sort of thing is that fi we merge
it, it ends up getting used more often than one expected...


If you stand back and squint at it, there are quite a few places where we
do this sort of thing: allocate a buffer, squirt characters into it,
reallocating and/or flushing as we proceed.  All sysfs and procfs read-side
code, for a start...
