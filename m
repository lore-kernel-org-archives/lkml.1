Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZJ0GfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZJ0GfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZJ0GfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:35:01 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:41080 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZJ0GfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=W99kUTrSYtkRuCIZybSVjaXXBilRAOpfyIt3jD+OiJ0Sv+kkqvwNF3BLTYrfjI4NhC
         BR7YjeiRuK7f/Qac4tUo/HtmINPLpIAK+tzIFYqKqytGicBV+C9+LIbEYKOd2Bg0S70K
         ixq+nxMH5+u3/ATU4+rZ5zTYcJ+PunZARHud0=
Date: Tue, 27 Oct 2009 15:34:29 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, vedran.furac@gmail.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Memory overcommit
Message-Id: <20091027153429.b36866c4.minchan.kim@barrios-desktop>
In-Reply-To: <2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
References: <hav57c$rso$1@ger.gmane.org>
	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
	<hb2cfu$r08$2@ger.gmane.org>
	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
	<4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 15:10:52 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 2009/10/27 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> > On Mon, 26 Oct 2009 17:16:14 +0100
> > Vedran Furač <vedran.furac@gmail.com> wrote:
> >> >  - Could you show me /var/log/dmesg and /var/log/messages at OOM ?
> >>
> >> It was catastrophe. :) X crashed (or killed) with all the programs, but
> >> my little program was alive for 20 minutes (see timestamps). And for
> >> that time computer was completely unusable. Couldn't even get the
> >> console via ssh. Rally embarrassing for a modern OS to get destroyed by
> >> a 5 lines of C run as an ordinary user. Luckily screen was still alive,
> >> oomk usually kills it also. See for yourself:
> >>
> >> dmesg: http://pastebin.com/f3f83738a
> >> messages: http://pastebin.com/f2091110a
> >>
> >> (CCing to lklm again... I just want people to see the logs.)
> >>
> > Thank you for reporting and your patience. It seems something strange
> > that your KDE programs are killed. I agree.
> >
> > I attached a scirpt for checking oom_score of all exisiting process.
> > (oom_score is a value used for selecting "bad" processs.")
> > please run if you have time.
> >
> > This is a result of my own desktop(on virtual machine.)
> > In this environ (Total memory is 1.6GBytes), mmap(1G) program is running.
> >
> > %check_badness.pl | sort -n | tail
> > --
> > 89924   3938    mixer_applet2
> > 90210   3942    tomboy
> > 94753   3936    clock-applet
> > 101994  3919    pulseaudio
> > 113525  4028    gnome-terminal
> > 127340  1       init
> > 128177  3871    nautilus
> > 151003  11515   bash
> > 256944  11653   mmap
> > 425561  3829    gnome-session
> > --
> > Sigh, gnome-session has twice value of mmap(1G).
> > Of course, gnome-session only uses 6M bytes of anon.
> > I wonder this is because gnome-session has many children..but need to
> > dig more. Does anyone has idea ?
> > (CCed kosaki)
> 
> Following output address the issue.
> The fact is, modern desktop application linked pretty many library. it
> makes bloat VSS size and increase
> OOM score.
> 
> Ideally, We shouldn't account evictable file-backed mappings for oom_score.
> 
Hmm. 
I wonder why we consider VM size for OOM kiling. 
How about RSS size?


-- 
Kind regards,
Minchan Kim
