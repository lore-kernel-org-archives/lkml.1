Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYJWAXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYJWAXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYJWAWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:22:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYJWAWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:22:54 -0400
Date: Wed, 22 Oct 2008 17:22:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned
 htree hash algorithms
Message-Id: <20081022172221.c1a8c5b5.akpm@linux-foundation.org>
In-Reply-To: <1224560624-9691-2-git-send-email-tytso@mit.edu>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu>
	<1224560624-9691-2-git-send-email-tytso@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 23:43:44 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> +	i = le32_to_cpu(es->s_flags);
> +	if (i & EXT2_FLAGS_UNSIGNED_HASH)
> +		sbi->s_hash_unsigned = 3;
> +	else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
> +		char	c;
> +
> +		c = (char) 255;
> +		if (((int) c) == -1) {

arm says

fs/ext3/super.c: In function `ext3_fill_super':
fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type

Also, is there any way in which this new code can be, umm, cleaned up?
