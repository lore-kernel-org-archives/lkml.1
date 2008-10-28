Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYJ1GQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYJ1GQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYJ1GQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:16:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYJ1GQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:16:27 -0400
Date: Mon, 27 Oct 2008 23:15:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Implement generic freeze feature
Message-Id: <20081027231533.96c42a78.akpm@linux-foundation.org>
In-Reply-To: <20081027215855t-sato@mail.jp.nec.com>
References: <20081027215855t-sato@mail.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 21:58:54 +0900 Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> -void thaw_bdev(struct block_device *bdev, struct super_block *sb)
> +int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  {
> +	int error = 0;
> +
> +	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	if (!bdev->bd_fsfreeze_count) {
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return -EINVAL;

This would be a programming error, yes?

If so, a WARN_ON is more appropriate than a silent runtime error.

> +	}
