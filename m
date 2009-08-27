Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbZH0Vzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbZH0Vzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZH0Vzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:55:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZH0Vzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:55:46 -0400
Date: Thu, 27 Aug 2009 14:53:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-afs@lists.infradead.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, anton@samba.org,
       stable@kernel.org
Subject: Re: [PATCH] AFS: Stop readlink() on AFS crashing because file not
 passed to afs_readpage()
Message-Id: <20090827145359.87367779.akpm@linux-foundation.org>
In-Reply-To: <20090827122231.14557.79687.stgit@warthog.procyon.org.uk>
References: <20090827122231.14557.79687.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 13:22:31 +0100
David Howells <dhowells@redhat.com> wrote:

> kAFS crashes when asked to read a symbolic link because page_getlink() passes a
> NULL file pointer to read_mapping_page(), but afs_readpage() expects a file
> pointer from which to extract a key.
> 
> Modify afs_readpage() to request the appropriate key from the calling process's
> keyrings if a file struct is not supplied with one attached.

That seems like a rather large bug.

To which kernel version(s) should we apply this?

Thanks.
