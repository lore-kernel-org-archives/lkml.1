Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbZEMWEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbZEMWEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761795AbZEMWEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:04:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761488AbZEMWEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:04:32 -0400
Date: Wed, 13 May 2009 15:04:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "B. N. Poornima" <poornima@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix potential Divide by Zero error in ext2_get_inode()
Message-Id: <20090513150425.89ac9b1c.akpm@linux-foundation.org>
In-Reply-To: <4A0A82ED.2040906@in.ibm.com>
References: <4A0A82ED.2040906@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 13:51:01 +0530
"B. N. Poornima" <poornima@in.ibm.com> wrote:

> Found a line of code in ext2_get_inode function of inode.c in the ext2 
> filesystem that has the potential of hitting the divide by 0 error.
> *************************************************
>  block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
> *************************************************
> There is no checking done here to verify if EXT2_INODES_PER_GROUP() 
> returns 0. This could result in divide by zero error and panic the system.
> Below is the patch, built against 2.6.30-rc5,  to correct the same:

EXT2_INODES_PER_GROUP() cannot return zero.  See ext2_fill_super():

	if (sbi->s_inodes_per_block == 0 || sbi->s_inodes_per_group == 0)
		goto cantfind_ext2;

