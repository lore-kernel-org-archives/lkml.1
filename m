Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbXH3QeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbXH3QeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbXH3QeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:34:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49471 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbXH3Qd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:33:59 -0400
Date: Thu, 30 Aug 2007 17:33:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
Subject: Re: [PATCH 1/3] VFS: make notify_change pass ATTR_KILL_S*ID to setattr operations
Message-ID: <20070830163356.GA12512@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org,
	nfs@lists.sourceforge.net
References: <200708301506.l7UF6c63002133@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708301506.l7UF6c63002133@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 11:06:38AM -0400, Jeff Layton wrote:
> Make notify_change not clear the ATTR_KILL_S*ID bits in the ia_vaid that
> gets passed to the setattr inode operation. This allows the filesystems
> to reinterpret whether this mode change is simply intended to clear the
> setuid/setgid bits.
> 
> This means that notify_change should never be called with both ATTR_MODE
> and either of the ATTR_KILL_S*ID bits set, since the filesystem would
> have no way to know what part of the mode change was intentional. If
> it is called this way, consider it a BUG().

This one looks fine to, but you'll probably need an additional patch
to ecryptfs so it clears ATTR_MODE before calling notify_change for
the lower inode.

