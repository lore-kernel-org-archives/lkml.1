Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYAEJqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYAEJqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYAEJqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:46:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40500 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYAEJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:46:04 -0500
Date: Sat, 5 Jan 2008 09:46:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080105094602.GI27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com> <20080103141033.GT27894@ZenIV.linux.org.uk> <20080105013126.d90c4e09.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105013126.d90c4e09.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:31:26AM -0800, Andrew Morton wrote:
> On Thu, 3 Jan 2008 14:10:33 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > 
> > which would not manage to return ERR_PTR(-EIO), no matter what - it would
> > die on access to inode->i_state.  I don't have -mm tree at hand, check if
> > there's anything affected in these areas.  Perhaps somebody tried to pass
> > error values from isofs_iget() and forgot to update callers?
> 
> Yep.  Unlike 2.6.24-rc5-mm1, 2.6.24-rc6-mm1 has
> 
> iget-stop-isofs-from-using-read_inode-fix-2.patch
> iget-stop-isofs-from-using-read_inode-fix-2-update.patch
> 
> so hopefully this was all fixed.

Nope; missed by both; fix (and fix to fix) had been posted, but IMO it's
better to replace the entire sorry pile with new variant of patch dhowells
had posted - it has all fixes folded in.
