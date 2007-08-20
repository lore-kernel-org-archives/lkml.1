Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXHTXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXHTXBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXHTXBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:01:00 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:59642 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbXHTXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:00:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 19:00:59 EDT
Date: Mon, 20 Aug 2007 15:54:15 -0700
To: linux-kernel@vger.kernel.org
Subject: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070820225415.GL3956@digitalkingdom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's to me appreciated)

It would be really, really nice if "umount -f" against a hung NFS
mount actually worked on Linux.  As much as I hate Solaris, I
consider it the gold standard in this case: If I say
"umount -f /mount/that/is/hung" it just goes away, immediately, and
anything still trying to use it dies (with EIO, I'm told).

If I know the NFS server is down, that really is the correct
behaviour.  I very much want this behaviour, and am willing to
bribe/pay for it, although my resources are limited.

Unless you're interested in details of my tests, stop here.

I'm bringing this up again (I know it's been mentioned here before)
because I had been told that NFS support had gotten better in Linux
recently, so I have been (for my $dayjob) testing the behaviour of
NFS (autofs NFS, specifically) under Linux with hard,intr and using
iptables to simulate a hang.  fuser hangs, as far as I can tell
indefinately, as does lsof. umount -f returns after a long time with
"busy", umount -l works after a long time but leaves the system in a
very unfortunate state such that I have to kill things by hand and
manually edit /etc/mtab to get autofs to work again.

The "correct solution" to this situation according to
http://nfs.sourceforge.net/ is cycles of "kill processes" and
"umount -f".  This has two problems:  1.  It sucks.  2.  If fuser
and lsof both hand (and they do: fuser has been on
"stat("/home/rpowell/"," for > 30 minutes now), I have no way to
pick which processes to kill.

I've read every man page I could find, and the only nfs option that
semes even vaguely helpful is "soft", but everything that mentions
"soft" also says to never use it.

This is the single worst aspect of adminning a Linux system that I,
as a carreer sysadmin, have to deal with.  In fact, it's really the
only one I even dislike. At my current work place, we've lost
multiple person-days to this issue, having to go around and reboot
every Linux box that was hanging off a down NFS server.

I know many other admins who also really want Solaris style
"umount -f"; I'm sure if I passed the hat I could get a decent
bounty together for this feature; let me know if you're interested.

Thanks.

-Robin

-- 
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
Reason #237 To Learn Lojban: "Homonyms: Their Grate!"
Proud Supporter of the Singularity Institute - http://singinst.org/
