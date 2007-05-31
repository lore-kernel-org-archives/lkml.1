Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbXEaKsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbXEaKsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbXEaKrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:47:55 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:44234 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758416AbXEaKrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:47:55 -0400
Date: Thu, 31 May 2007 12:47:53 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-Id: <20070531124753.a99f713c.dada1@cosmosbay.com>
In-Reply-To: <20070531103316.GO32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 12:33:16 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi,
> 
> This patch removes the ->sendfile() hook from the file_operations
> structure, and replaces the sys_sendfile() mechanism to be based on
> ->splice_read() instead. There should be no functional changes.
> 
  
> -	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
> +	fl = 0;
> +	if (in_file->f_flags & O_NONBLOCK)
> +		fl = SPLICE_F_NONBLOCK;
> +
> +	retval = do_splice_direct(in_file, ppos, out_file, count, fl);

I like this, but are you sure it wont break user land ?

Some applications might react badly if sendfile() returns EAGAIN ?

