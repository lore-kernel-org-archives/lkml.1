Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYEaIWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYEaIWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYEaIWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:22:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40991 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYEaIWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:22:11 -0400
Date: Sat, 31 May 2008 04:22:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: Re: [patch 3/8] Make d_path() consistent across mount operations
Message-ID: <20080531082210.GD24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113310.608958055@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113310.608958055@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:48PM +0200, Miklos Szeredi wrote:
> The path that __d_path() computes can become slightly inconsistent when it
> races with mount operations: it grabs the vfsmount_lock when traversing mount
> points but immediately drops it again, only to re-grab it when it reaches the
> next mount point.  The result is that the filename computed is not always
> consisent, and the file may never have had that name. (This is unlikely, but
> still possible.)
> 
> Fix this by grabbing the vfsmount_lock for the whole duration of
> __d_path().

Looks good, and lock holding times shouldn't be a problem either.

