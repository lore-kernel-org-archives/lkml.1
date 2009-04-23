Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZDWTSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZDWTSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZDWTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:18:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45739 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521AbZDWTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:18:24 -0400
Date: Thu, 23 Apr 2009 20:18:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5 -tip] umount_begin BKL pushdown
Message-ID: <20090423191817.GW8633@ZenIV.linux.org.uk>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240513925-5603-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:12:00PM +0200, Alessio Igor Bogani wrote:
> Push the BKL acquisition from vfs to every specific filesystems
> with hope that it can be eliminated in a second moment.
> 
> The first 4 patches add BKL lock into umount_begin() functions (for
> the filesystems that have this handler). The last one remove
> lock_kernel()/unlock_kernel() from fs/namespace.c (the only point
> that invoke umount_begin() funtcions).

I'd rather collapse all these patches together; no point doing that
per-fs (for all 4 of them).  And CIFS side is bogus.

Another thing: -tip is no place for that.  I can put that into VFS
tree, provided that comments above are dealt with.
