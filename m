Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXCUGfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXCUGfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXCUGfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:35:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbXCUGfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:35:45 -0400
Date: Tue, 20 Mar 2007 22:30:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Subject: Re: [PATCH] Turn do_sync_file_range() into do_sync_mapping_range()
Message-Id: <20070320223041.22e24403.akpm@linux-foundation.org>
In-Reply-To: <20070320214626.GC23274@ca-server1.us.oracle.com>
References: <20070320214626.GC23274@ca-server1.us.oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 14:46:26 -0700 Mark Fasheh <mark.fasheh@oracle.com> wrote:

> do_sync_file_range() accepts a file * from which it takes an address_space
> to sync. Abstract out the bulk of the function into do_sync_mapping_range()
> which takes the address_space directly. This way callers who want to sync an
> address_space directly can take advantage of the functionality provided.
> 
> do_sync_file_range() is preserved as a 3 line wrapper around
> do_sync_mapping_range().
> 
> Ocfs2 in particular would like to use this to initiate a sync of a specific
> inode range during truncate, where a file * may not be available.

I think we can remove do_sync_file_range() altogether?
