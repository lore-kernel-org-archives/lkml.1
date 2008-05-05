Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYEEMkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYEEMkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYEEMj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:39:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59121 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYEEMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:39:55 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, drepper@redhat.com
In-reply-to: <20080505113042.GA28997@infradead.org> (message from Christoph
	Hellwig on Mon, 5 May 2008 07:30:42 -0400)
Subject: Re: [patch 13/15] vfs: utimes cleanup
References: <20080505095440.820370974@szeredi.hu> <20080505095528.826574311@szeredi.hu> <20080505113042.GA28997@infradead.org>
Message-Id: <E1Jszyt-0005wE-Ue@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 14:39:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Untange the mess that is do_utimes()
> 
> A good idea to untangle this, but I'm not entirely happy with how it's
> done.
> 
> utimes_need_permission is a good helper and fine with me.
> 
> utimes_common is a good idea aswell, but I'd rather take the permission
> checks into it aswell, even if that means a little flag telling if
> file->f_mode should be checked or vfs_permission().

How would that be better?  There's zero commonality between the two
kinds of permission checks (other than utimes_need_permission()).

> do_fd_utimes sounds fine, but I don't like that name.  do_futimes maybe?

Whatever you prefer.  It's a static function, so it's not really a big
issue.

> and when the fd-side is sorted out the path side should probably be a
> helper aswell.  Then sys_utime/sys_utimes/arhc bits could call it directly,
> with the initial check in do_utimes separated out into a helper ala
> utimes_need_permission.  do_utimes should probably become do_futimesat
> at the point.

OK, makes sense.

Miklos
