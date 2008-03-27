Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbYC0GOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbYC0GOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 02:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYC0GNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 02:13:54 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:12461 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYC0GNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 02:13:54 -0400
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
References: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2008 07:13:50 +0100
In-Reply-To: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
Message-ID: <87k5jon17l.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Mar 2008 06:07:12.0111 (UTC) FILETIME=[CC2697F0:01C88FD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland <me@bobcopeland.com> writes:
> +
> +	bitmap_size = (sbi->s_num_blocks + 7) / 8;
> +	array_size = (bitmap_size + sb->s_blocksize - 1) / sb->s_blocksize;
> +
> +	sbi->s_imap_size = array_size;
> +	sbi->s_imap = kzalloc(array_size * sizeof(unsigned long), GFP_KERNEL);


If the array can be really 300k you should probably have a vmalloc fallback
here.

-Andi
