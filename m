Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbXE2OtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbXE2OtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXE2Os5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:48:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1703 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbXE2Os4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:48:56 -0400
Date: Tue, 29 May 2007 14:45:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Crispin Cowan <crispin@novell.com>
Cc: Cliffe <cliffe@iinet.net.au>, casey@schaufler-ca.com,
       Kyle Moffett <mrmacman_g4@mac.com>,
       linux-security-module <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070529144518.GD5840@ucw.cz>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <465AE46B.4090109@iinet.net.au> <465B57D7.2040101@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465B57D7.2040101@novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If we want "/etc/shadow" to be the only way to access the shadow file
> > we could label the data with "/etc/shadow". Any attempts to access
> > this data using a renamed file or link would be denied (attempts to
> > link or rename could also be denied).
> Eloquently put.
> 
> AppArmor actually does something similar to this, by mediating all of
> the ways that you can make an alias to a file. These are:
...
>     * Hard links: AppArmor explicitly mediates permission to make a hard

Unfortunately, aparmor is by design limited to subset of distro
(network daemons). Unfortunately, some other programs (passwd, vi)
routinely make hardlinks. So AA mediating hardlink is not enough, as
vi will happily hardlink /etc/shadow into /etc/.vi-shadow-1234.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
