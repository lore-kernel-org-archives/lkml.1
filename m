Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbXHUQoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbXHUQoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXHUQn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:43:56 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:44141 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbXHUQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:43:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18123.5699.405125.137517@stoffel.org>
Date: Tue, 21 Aug 2007 12:43:47 -0400
From: "John Stoffel" <john@stoffel.org>
To: Robin Lee Powell <rlpowell@digitalkingdom.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: <20070820225415.GL3956@digitalkingdom.org>
References: <20070820225415.GL3956@digitalkingdom.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Robin> I'm bringing this up again (I know it's been mentioned here
Robin> before) because I had been told that NFS support had gotten
Robin> better in Linux recently, so I have been (for my $dayjob)
Robin> testing the behaviour of NFS (autofs NFS, specifically) under
Robin> Linux with hard,intr and using iptables to simulate a hang.

So why are you mouting with hard,intr semantics?  At my current
SysAdmin job, we mount everything (solaris included) with 'soft,intr'
and it works well.  If an NFS server goes down, clients don't hang for
large periods of time. 

Robin> fuser hangs, as far as I can tell indefinately, as does
Robin> lsof. umount -f returns after a long time with "busy", umount
Robin> -l works after a long time but leaves the system in a very
Robin> unfortunate state such that I have to kill things by hand and
Robin> manually edit /etc/mtab to get autofs to work again.

Robin> The "correct solution" to this situation according to
Robin> http://nfs.sourceforge.net/ is cycles of "kill processes" and
Robin> "umount -f".  This has two problems:  1.  It sucks.  2.  If fuser
Robin> and lsof both hand (and they do: fuser has been on
Robin> "stat("/home/rpowell/"," for > 30 minutes now), I have no way to
Robin> pick which processes to kill.

Robin> I've read every man page I could find, and the only nfs option
Robin> that semes even vaguely helpful is "soft", but everything that
Robin> mentions "soft" also says to never use it.

I think the man pages are out of date, or ignoring reality.  Try
mounting with soft,intr and see how it works for you.  I think you'll
be happy.  

Robin> This is the single worst aspect of adminning a Linux system that I,
Robin> as a carreer sysadmin, have to deal with.  In fact, it's really the
Robin> only one I even dislike. At my current work place, we've lost
Robin> multiple person-days to this issue, having to go around and reboot
Robin> every Linux box that was hanging off a down NFS server.

Robin> I know many other admins who also really want Solaris style
Robin> "umount -f"; I'm sure if I passed the hat I could get a decent
Robin> bounty together for this feature; let me know if you're interested.

Robin> Thanks.

Robin> -Robin

Robin> -- 
Robin> http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
Robin> Reason #237 To Learn Lojban: "Homonyms: Their Grate!"
Robin> Proud Supporter of the Singularity Institute - http://singinst.org/
Robin> -
Robin> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Robin> the body of a message to majordomo@vger.kernel.org
Robin> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Robin> Please read the FAQ at  http://www.tux.org/lkml/


Robin> !DSPAM:46ca1d9676791030010506!
