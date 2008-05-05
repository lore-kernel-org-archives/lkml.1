Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYEELa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYEELa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYEELaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:30:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYEELap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:30:45 -0400
Date: Mon, 5 May 2008 07:30:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 13/15] vfs: utimes cleanup
Message-ID: <20080505113042.GA28997@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095528.826574311@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095528.826574311@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:54AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Untange the mess that is do_utimes()

A good idea to untangle this, but I'm not entirely happy with how it's
done.

utimes_need_permission is a good helper and fine with me.

utimes_common is a good idea aswell, but I'd rather take the permission
checks into it aswell, even if that means a little flag telling if
file->f_mode should be checked or vfs_permission().

do_fd_utimes sounds fine, but I don't like that name.  do_futimes maybe?

and when the fd-side is sorted out the path side should probably be a
helper aswell.  Then sys_utime/sys_utimes/arhc bits could call it directly,
with the initial check in do_utimes separated out into a helper ala
utimes_need_permission.  do_utimes should probably become do_futimesat
at the point.

