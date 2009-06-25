Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZFYEzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZFYEzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZFYEyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:54:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZFYEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:54:53 -0400
Date: Thu, 25 Jun 2009 05:54:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH] lseek: remove i_mutex
Message-ID: <20090625045452.GA8633@ZenIV.linux.org.uk>
References: <6.0.0.20.2.20090625115833.05a9ce10@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090625115833.05a9ce10@172.19.0.2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 01:41:10PM +0900, Hisashi Hifumi wrote:
> Hi, 
> 
> Following patch removes i_mutex from generic_file_llseek.
> I think the reason of protecting lseek with i_mutex is just
> touching i_size (and f_pos) atomically.

NAK.  There's also a lot of fun with directories - readdir() vs. llseek().
