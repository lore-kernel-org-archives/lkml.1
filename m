Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYAOR16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYAOR16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYAOR1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:27:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56681 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYAOR1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:27:47 -0500
Date: Tue, 15 Jan 2008 17:27:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, alan@redhat.com,
       viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 4/8] revoke: core code V7
Message-ID: <20080115172741.GA20388@infradead.org>
References: <Pine.LNX.4.64.0712141716370.28689@sbz-30.cs.Helsinki.FI> <1200410094.26045.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200410094.26045.29.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 04:14:54PM +0100, Peter Zijlstra wrote:
> Humm, we were trying to get rid of file_list_lock(), this puts up
> another user of the sb file list.
> 
> Also, that loop looks horribly expensive: n*(1+m); where n is the list
> size, and m the number of matching fds.
> 
> Granted, I see no other options either.

Something like the loop above is not going to go in for sure.  Once we
get rid of the sb->s_files we can put the list_head in struct file to
new use eventually if we don't want to get rid of it.  E.g. and
per-inode list would be much better than the per-superblock one and
would regularize what the tty driver is doing.

But I'm not too interesting in hashing out these details currently,
my primary concern is to get the per-mount r/o plus fallout like the
correct remount r/o and file_list_lock removal in and stable first.

