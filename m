Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbXCZKhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbXCZKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXCZKhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:37:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52761 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXCZKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:37:51 -0400
Date: Mon, 26 Mar 2007 13:37:50 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: "Wu, Bryan" <bryan.wu@analog.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
In-Reply-To: <1174904637.32691.86.camel@roc-desktop>
Message-ID: <Pine.LNX.4.64.0703261335130.11483@sbz-30.cs.Helsinki.FI>
References: <1174904637.32691.86.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Wu, Bryan wrote:
> As struct mm_struct vm_mm is hidden in struct vm_area_struct in NOMMU
> arch, this is a fixing method when compiling failure on blackfin arch.

What compile error is that? I don't see any #ifdef around ->vm_mm for 
struct vm_area_struct in <linux/mm.h>.

On Mon, 26 Mar 2007, Wu, Bryan wrote:
> +	if (!mm)
> +		return -ENOENT;
> +
>  	details.i_mmap_lock = &mapping->i_mmap_lock;

This means you won't be able to revoke memory mapped files with no-MMU. 
I'd rather fix it properly if someone can give me a clue how mmap works on 
non-MMU.

			Pekka
