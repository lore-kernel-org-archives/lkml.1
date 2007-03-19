Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbXCSOwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbXCSOwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXCSOwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:52:30 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:46675 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbXCSOwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:52:30 -0400
Date: Mon, 19 Mar 2007 15:52:28 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, take3] getrusage() : Fill ru_inblock and ru_oublock
 fields if possible
Message-Id: <20070319155228.00b0d875.dada1@cosmosbay.com>
In-Reply-To: <20070319143723.GA152@tv-sign.ru>
References: <20070319130213.bb387150.dada1@cosmosbay.com>
	<20070319143723.GA152@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:37:23 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:
> (offtopic)

Well..., it *is*  ontopic I'm afraid...

> 
> We are reading u64 read_bytes/write_bytes which could be updated asynchronously.
> /proc/pid/io does the same.
> 
> Of course, I don't blame this patch, just a stupid question: can we do something?
> I guess not.

We could do a proper thing with a seqlock (only needed on 32bit arches)
See for example what is done for i_size in struct inode, with i_size_seqcount

Eric
