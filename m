Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYFWSuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYFWSuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbYFWSup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:50:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYFWSuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:50:44 -0400
Date: Mon, 23 Jun 2008 19:50:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch v3] vfs: fix sys_getcwd for detached mounts
Message-ID: <20080623185043.GZ28946@ZenIV.linux.org.uk>
References: <E1KAqjG-00080e-KH@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KAqjG-00080e-KH@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:25:26PM +0200, Miklos Szeredi wrote:
> I tested this one in various situations, and it appears to do what
> it's supposed to.
> 
> A somewhat analogous issue is if we have cwd (or fd) outside
> current->root.  Should we add a prefix for that case as well?  Perhaps
> a double slash?

OK, I've applied everything except the last one (all in for-linus in
vfs-2.6.git).  As for the stuff outside current->root (or other namespace,
for that matter)...  I don't like the idea of using // - as it is,
we have a nice sane check (path[0] != '/') and if anything, I'd consider
going for deleted:<path> instead of <path> (deleted) as we have now.
_That_ would eliminate the major annoyance with handling of unlinked/rmdired -
we'd get rid of guessing whether that's a file really called "a (deleted)"
or an unlinked one that used to be called "a"...
