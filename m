Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYAEJcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYAEJcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYAEJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:31:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436AbYAEJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:31:45 -0500
Date: Sat, 5 Jan 2008 01:31:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-Id: <20080105013126.d90c4e09.akpm@linux-foundation.org>
In-Reply-To: <20080103141033.GT27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com>
	<20080103141033.GT27894@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 14:10:33 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> 
> which would not manage to return ERR_PTR(-EIO), no matter what - it would
> die on access to inode->i_state.  I don't have -mm tree at hand, check if
> there's anything affected in these areas.  Perhaps somebody tried to pass
> error values from isofs_iget() and forgot to update callers?

Yep.  Unlike 2.6.24-rc5-mm1, 2.6.24-rc6-mm1 has

iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-isofs-from-using-read_inode-fix-2-update.patch

so hopefully this was all fixed.
