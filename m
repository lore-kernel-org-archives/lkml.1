Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbYJRI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbYJRI6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYJRI6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:58:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42645 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYJRI6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:58:07 -0400
Message-ID: <48F9A441.3030400@cs.helsinki.fi>
Date: Sat, 18 Oct 2008 11:54:25 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Tom Zanussi <zanussi@comcast.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 1/21] relay - Clean up relay_switch_subbuf() and make
 waking up consumers optional.
References: <1224137126.16328.220.camel@charm-linux>
In-Reply-To: <1224137126.16328.220.camel@charm-linux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Tom Zanussi wrote:
> +static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
> +{
> +	if (buf->dentry)
> +		buf->dentry->d_inode->i_size +=	length;
> +	else
> +		buf->early_bytes += length;
> +
> +	smp_mb();
> +}

A minor nit: you should probably add a comment for that memory barrier. 
That is, explain why it is needed. It makes a world of a difference to 
anyone trying to understand what's going on here.
