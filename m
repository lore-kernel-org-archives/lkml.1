Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXDVLZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXDVLZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXDVLZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:25:09 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:52321 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbXDVLZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:25:08 -0400
Date: Sun, 22 Apr 2007 13:26:58 +0200
From: DervishD <lkml@dervishd.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070422112658.GB5786@DervishD>
Mail-Followup-To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Beisert <juergen127@kreuzholzen.de>,
	linux-kernel@vger.kernel.org
References: <20070419085750.GA2833@DervishD> <200704191352.06456.juergen127@kreuzholzen.de> <20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp> <20070421201841.85717088.akpm@linux-foundation.org> <87wt05vxu7.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wt05vxu7.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Ogawa (and Andrew) :)
 * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> dixit:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > Is there some way in which we can work out what's happened and fix
> > it up?
> 
> It seems that the recent Windows changed specification, and it's
> undocumented. Windows doesn't update ->free_clusters correctly.
> 
> Probably, what we can do is to throw away speed of statfs(2) and not
> using ->free_clusters. (And if possible, recover it by optimization.)

    Even if Windows updates ->free_clusters correctly, it doesn't even
consider it to compute the number of free clusters, and IMHO Linux
should do the same. If speed is a concern, ->free_clusters can be
computed at mount time. That way statfs won't slow.

    The problem is that if a program writes a file onto the filesystem
without using statfs first to check for free space, the free_clusters
entry won't have the real value and the driver may report "disk full" (I
haven't read the code for the vfat driver, sorry, so I'm not sure about
this) when really there are plenty of clusters to write the new file.

    Probably it's stupid to update the free clusters count at mount time
(sorry if so...) but it looks like a good idea to me. And of course, I
don't mean to update the value _on disk_, but the kernel's idea of free
clusters (so even FAT filesystems mounted R/O will report correct
values).

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
