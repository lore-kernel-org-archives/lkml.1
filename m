Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXFZUjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXFZUjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbXFZUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:39:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:30344 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbXFZUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Izt9Z+pO1jSbuuMyLdlhDVVkz+39jcHkTvpoE9o8iUIijCVjlynHYS+IGzjGEWrGZE4rToKDAnE9WH2vtLdfNmR4mv0CqRPgNgPhyRsbcWn4xKHHy/GUR59WqqMcP1KFaXpzuxSOY9+MR3wR0WCautkURC8VVJnSl8ItutlVvcs=
From: Andreas Hartmetz <ahartmetz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Tue, 26 Jun 2007 22:39:04 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706262239.05070.ahartmetz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > We dropped OSS for ALSA for technical reasons. Those being that ALSA
> > - has a better audio API

> You mean the undocumented, 100% ioctl one?  With one ioctl to write
> interleaved sound, one for non-interleaved sound, in addition to
> setting interleaved or not in the configuration?  I should check one
> day which one wins.

> Or the "library"?  Don't get me started on this one.

> I take your word about the fact that the kernel side is better.

Okay, here's a rant.

As an interested kernel outsider and KDE developer(*), it looks to me like 
most kernel people are  too focused on the history and feature lists of the 
particular technologies here. 

The real matter with ALSA is that you get a strong "ALSA hates me" feeling 
when dealing with it. There is bad documentation, bad API, and a config file 
syntax that is much harder to understand than necessary.

Then there is the kernel/library split that seems to have no convincing reason 
at all in its current form.
Why not put the whole sound system in userland? It has been done before. Sound 
is just not performance critical at all and it's almost never mission 
critical.
Plus you wouldn't have to cross the userland/kernel gap to implement new and 
exciting things that way. Audio is kinda simple on the IO level (I hope I'm 
right there :) ) and, ideally, on the userland API level. These places are 
exactly where well-defined interfaces should be. An appropriate IO interface 
and userland API should be set in stone, not something arbitrary in between. 
Hell, there could even be a source compatible sound driver standard for all 
Unix-like free OS kernels.

The track record of ALSA for me goes like this:

- dmix finally started working automatically (at least on my Kubuntu system) 
about one year ago, about five years after everybody could see that this was 
badly needed. I couldn't get it to work before. The howtos somehow didn't 
work and ALSA's documentation isn't all that helpful.

- Different desktop environments have different sound daemons to paper over 
the weaknesses of ALSA (no dmix by default / unfriendly API), which creates 
new problems. Yes there are other reasons for sound daemons, but I doubt 
anybody would have come up with the idea if it wasn't for ALSA.

- I have an Envy24HT based soundcard in my desktop PC, which also goes to show 
that I'm really interested in sound issues. I have to run alsamixer after 
every bootup to unmute the left channel because restoring volume only works 
for the right channel. The left channel starts working after changing its 
volume.

- On my IBM/Lenovo R50e notebook with Intel chipset sound didn't work before 
I "muted" the "headphone jack sense" control in alsamixer. That took two 
hours or so. When both the master volume and the PCM volume control are set 
to 100% I get really bad clipping problems.

- Some time ago ALSA reported that my soundcard supports sampling rates it 
doesn't in fact support. This was fixed by Takashi Iwai after a week and two 
mails or so. Thumbs up.

Regards,
Andreas

(*) I am not representing KDE in an official way at all, but I can say  that 
KDE developers generally put *much* effort into making APIs as logical and 
friendly as they possibly can.
