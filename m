Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbXFNUHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbXFNUHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXFNUHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:07:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbXFNUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:07:05 -0400
Date: Thu, 14 Jun 2007 13:06:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614130645.cabdff1b.akpm@linux-foundation.org>
In-Reply-To: <20070614193839.878721298@sgi.com>
References: <20070614193839.878721298@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 12:38:39 -0700
clameter@sgi.com wrote:

> This patchset cleans up the page cache handling by replacing
> open coded shifts and adds through inline function calls.

If we never inflict variable PAGE_CACHE_SIZE upon the kernel, these changes
become pointless obfuscation.

Let's put our horses ahead of our carts.  We had a lengthy discussion about
variable PAGE_CACHE_SIZE in which I pointed out that the performance
benefits could be replicated in a manner which doesn't add complexity to
core VFS and which provides immediate benefit to all filesystems without
any need to alter them: populate contiguous pagecache pages with physically
contiguous pages.

I think the best way to proceed would be to investigate that _general_
optimisation and then, based upon the results of that work, decide whether
further _specialised_ changes such as variable PAGE_CACHE_SIZE are needed,
and if so, what they should be.

