Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbXFJRpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbXFJRpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbXFJRo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:44:57 -0400
Received: from lazybastard.de ([212.112.238.170]:47891 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXFJRo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:44:56 -0400
Date: Sun, 10 Jun 2007 19:40:11 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 10/18] fs/logfs/inode.c
Message-ID: <20070610174011.GB32619@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184636.GK8952@lazybastard.org> <200706101924.29927.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706101924.29927.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 June 2007 19:24:28 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +struct inode *logfs_new_inode(struct inode *dir, int mode)
> > +{
> > +       struct super_block *sb = dir->i_sb;
> > +       struct inode *inode;
> > +
> > +       inode = new_inode(sb);
> > +       if (!inode)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       logfs_init_inode(inode);
> > +
> > +       inode->i_mode = mode;
> > +       inode->i_ino = logfs_get_ino(sb);
> > +
> > +       insert_inode_hash(inode);
> > +
> > +       return inode;
> > +}
> 
> I think this is missing code that sets the initial i_uid/i_gid,
> but there may be more missing. Changing the uid value works,
> but creating files as non-root user doesn't.

Eek!  I'll have a look.

Jörn

-- 
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley
