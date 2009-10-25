Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZJYTME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZJYTME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZJYTMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:12:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZJYTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:12:02 -0400
Date: Sun, 25 Oct 2009 07:29:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: symlinks with permissions
Message-ID: <20091025062953.GC1391@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...yes, they do exist, in /proc/self/fd/* . Unfortunately, their
permissions are not actually checked during open, resulting in
(obscure) security hole: if you have fd open for reading, you can
reopen it for write, even through unix permissions would not allow
that.

Now... I'd like to close the hole. One way would be to actually check
symlink permissions on open -- because those symlinks already have
correct permissions.

But ... then I got lost in vfs. Can someone help? Is there better way?

    	       	   	   	    	    	     	   	  Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
