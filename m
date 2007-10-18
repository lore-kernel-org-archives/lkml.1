Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbXJREHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbXJREHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXJREH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:07:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbXJREHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:07:25 -0400
Date: Wed, 17 Oct 2007 21:07:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       sho@tnes.nec.co.jp, clameter@sgi.com
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Message-Id: <20071017210708.75011e02.akpm@linux-foundation.org>
In-Reply-To: <20071011111849.GC7125@duck.suse.cz>
References: <20070828190551.415127746@sgi.com>
	<20070828190735.292638294@sgi.com>
	<1188432669.3799.35.camel@localhost.localdomain>
	<1188434857.3799.76.camel@localhost.localdomain>
	<1191285346.11737.58.camel@localhost.localdomain>
	<20071004131207.65406a7b.akpm@linux-foundation.org>
	<20071011111849.GC7125@duck.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 13:18:49 +0200 Jan Kara <jack@suse.cz> wrote:

> +static inline __le16 ext2_rec_len_to_disk(unsigned len)
> +{
> +	if (len == (1 << 16))
> +		return cpu_to_le16(EXT2_MAX_REC_LEN);
> +	else if (len > (1 << 16))
> +		BUG();
> +	return cpu_to_le16(len);
> +}

Of course, ext2 shouldn't be trying to write a bad record length into a
directory entry.  But are we sure that there is no way in which this
situation could occur is the on-disk data was _already_ bad?

Because it is very bad for a fileysstem to go BUG in response to unexpected
data on the disk.

