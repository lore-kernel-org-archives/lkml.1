Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXJ3BTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXJ3BTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJ3BTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:19:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43677 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbXJ3BTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:19:09 -0400
Date: Tue, 30 Oct 2007 02:19:07 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lee Revell <rlrevell@joe-job.com>
cc: Greg KH <greg@kroah.com>, Tilman Schmidt <tilman@imap.cc>,
       Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Out-of-tree modules [was: Linux Security *Module* Framework]
In-Reply-To: <75b66ecd0710291746m7aec81bdsb6ddc0822439ff46@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710300208170.27075@fbirervta.pbzchgretzou.qr>
References: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> 
 <471E9260.6000704@goop.org>  <20071023220649.5a76af82@laptopd505.fenrus.org>
  <55615.simon.1193226629@5ec7c279.invalid>  <20071024125533.GE30533@stusta.de>
  <471F8AC5.9080300@simon.arlott.org.uk>  <20071024223124.GI30533@stusta.de>
 <4721221A.1020309@imap.cc>  <20071026025647.GC21408@kroah.com> 
 <Pine.LNX.4.64.0710260900280.25696@fbirervta.pbzchgretzou.qr>
 <75b66ecd0710291746m7aec81bdsb6ddc0822439ff46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29 2007 20:46, Lee Revell wrote:
>On 10/29/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> quad_dsp - http://jengelh.hopto.org/p/quad_dsp/
>>
>> Provides a /dev/dsp style node for legacy applications that support
>> neither ALSA nor the AOSS wrapper nor more-than-2-channel sound.
>>
>
>(I think that should read "AND more than 2 channel sound")

It is for programs that only give out 2 channels of audio data.
Qdsp_dpl2 is a node that applies the DPL2 matrix on these two channels,
yielding the rear 2 channels, giving some sort of surround effect.

>Couldn't ALSA's OSS emulation be extended to support more than 2
>channels per device node?

I figured that exceeded my skills at that time.

>> thkd - ftp://ftp5.gwdg.de/pub/linux/misc/suser-jengelh/kernel/linux-2.6.23.1-ccj58/thkd.diff
>>
>> Workaround for Toshiba MK2003GAH hard-drive head auto-unloading after
>> 5-15 seconds. (Ref: http://lkml.org/lkml/2006/11/15/100 )
>
>It looks like this could be trivially fixed in a mergeable way.  That
>LKML thread petered out before the problem was seriously analyzed.
>
>Did you try the -Z flag of hdparm?

IIRC, yes, been through all sorts of hdparm options. -Z did not help
at all, and -B only prolonged the delay from 5 to around 15 seconds.
I contacted Tosh Corp (before posting on lkml) and while they know of
the 'issue', I did not get a satisfactory answer (namely how to FIX
it), so I thought why spend time slapping if there's a workaround...

Causing a minimal head seek every now and then (4096 bytes per 3
seconds is a somewhat small block size with a not-too-low interval)
is a working workaround for now. The module code is not top notch,
but I doubt I'll ever have more than one 1.8" MK2003GAH disk in the
same laptop.
