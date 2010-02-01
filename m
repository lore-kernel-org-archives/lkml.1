Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0BARwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:52:30 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:38211 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab0BARw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:52:27 -0500
Date: Mon, 1 Feb 2010 11:50:16 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Dave Chinner <david@fromorbit.com>
cc: Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
In-Reply-To: <20100130024329.GJ15853@discord.disaster>
Message-ID: <alpine.DEB.2.00.1002011148530.30861@router.home>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130024329.GJ15853@discord.disaster>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010, Dave Chinner wrote:

> How do you expect defrag to behave when the filesystem doesn't free
> the inode immediately during dispose_list()? That is, the above code
> only finds inodes that are still active at the VFS level but they
> may still live for a significant period of time after the
> dispose_list() call. This is a real issue now that XFS has combined
> the VFS and XFS inodes into the same slab...

Then the freeing of the slab has to be delayed until the objects are
freed.

