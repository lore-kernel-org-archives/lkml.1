Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbYDSWDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbYDSWDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYDSWDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:03:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:29785 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbYDSWDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IyVKHZ5cCEHJCYD08z+HXbHr91efs7DO8xpLoBoSOhacatrrxF/Q3jbvNj2IAG/h2VYtQnKZuxNsAMLu9RqbPSy2JpLF1rT4Pdl6AoHRXKHn/UI+4ZIUQ+QoQAgrH5XUD3gLiA3e3NMoS8jWFDHPgW24xPsH4PLSEKie7mGiqc4=
Date: Sun, 20 Apr 2008 00:03:12 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] omfs: add bitmap routines
Message-ID: <20080419220307.GB7888@joi>
References: <1208637457-24969-7-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208637457-24969-7-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 04:37:35PM -0400, Bob Copeland wrote:
> +unsigned long omfs_count_free(struct super_block *sb)
> +{
> +	unsigned int i, j;
> +	u64 *map;
> +	unsigned long sum = 0;
> +	struct omfs_sb_info *sbi = OMFS_SB(sb);
> +
> +	for (i = 0; i < sbi->s_imap_size; i++) {
> +		map = (u64 *) sbi->s_imap[i];
> +		for (j = 0; j < sb->s_blocksize / 8; j++)
> +			sum += hweight64(~map[j]);
> +	}
> +	return sum;
> +}
I think inner loop can be replaced with something like:
sum += sb->s_blocksize * 8 - bitmap_weight(map, sb->s_blocksize * 8);

Marcin
