Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbXHURCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbXHURCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXHURB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:01:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589AbXHURB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:01:58 -0400
Message-ID: <46CB1A78.7040102@redhat.com>
Date: Tue, 21 Aug 2007 13:01:44 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org>
In-Reply-To: <18123.5699.405125.137517@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> Robin> I'm bringing this up again (I know it's been mentioned here
> Robin> before) because I had been told that NFS support had gotten
> Robin> better in Linux recently, so I have been (for my $dayjob)
> Robin> testing the behaviour of NFS (autofs NFS, specifically) under
> Robin> Linux with hard,intr and using iptables to simulate a hang.
>
> So why are you mouting with hard,intr semantics?  At my current
> SysAdmin job, we mount everything (solaris included) with 'soft,intr'
> and it works well.  If an NFS server goes down, clients don't hang for
> large periods of time. 
>
>   

Wow!  That's _really_ a bad idea.  NFS READ operations which
timeout can lead to executables which mysteriously fail, file
corruption, etc.  NFS WRITE operations which fail may or may
not lead to file corruption.

Anything writable should _always_ be mounted "hard" for safety
purposes.  Readonly mounted file systems _may_ be mounted "soft",
depending upon what is located on them.

> Robin> fuser hangs, as far as I can tell indefinately, as does
> Robin> lsof. umount -f returns after a long time with "busy", umount
> Robin> -l works after a long time but leaves the system in a very
> Robin> unfortunate state such that I have to kill things by hand and
> Robin> manually edit /etc/mtab to get autofs to work again.
>
> Robin> The "correct solution" to this situation according to
> Robin> http://nfs.sourceforge.net/ is cycles of "kill processes" and
> Robin> "umount -f".  This has two problems:  1.  It sucks.  2.  If fuser
> Robin> and lsof both hand (and they do: fuser has been on
> Robin> "stat("/home/rpowell/"," for > 30 minutes now), I have no way to
> Robin> pick which processes to kill.
>
> Robin> I've read every man page I could find, and the only nfs option
> Robin> that semes even vaguely helpful is "soft", but everything that
> Robin> mentions "soft" also says to never use it.
>
> I think the man pages are out of date, or ignoring reality.  Try
> mounting with soft,intr and see how it works for you.  I think you'll
> be happy.  
>
>   

Please don't.  You will end up regretting it in the long run.
Taking a chance on corrupted data or critical applications which
just fail is not worth the benefit.

It would safer for us to implement something which works like
the Solaris forced umount support for NFS.

    Thanx...

       ps

> Robin> This is the single worst aspect of adminning a Linux system that I,
> Robin> as a carreer sysadmin, have to deal with.  In fact, it's really the
> Robin> only one I even dislike. At my current work place, we've lost
> Robin> multiple person-days to this issue, having to go around and reboot
> Robin> every Linux box that was hanging off a down NFS server.
>
> Robin> I know many other admins who also really want Solaris style
> Robin> "umount -f"; I'm sure if I passed the hat I could get a decent
> Robin> bounty together for this feature; let me know if you're interested.
>
> Robin> Thanks.
>
> Robin> -Robin
>
> Robin> -- 
> Robin> http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
> Robin> Reason #237 To Learn Lojban: "Homonyms: Their Grate!"
> Robin> Proud Supporter of the Singularity Institute - http://singinst.org/
> Robin> -
> Robin> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> Robin> the body of a message to majordomo@vger.kernel.org
> Robin> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Robin> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> Robin> !DSPAM:46ca1d9676791030010506!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

