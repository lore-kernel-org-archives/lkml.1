Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYI3PVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYI3PVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYI3PVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:21:31 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58833 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752720AbYI3PVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:21:30 -0400
Date: Tue, 30 Sep 2008 17:21:29 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Monty Montgomery <monty@xiph.org>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
In-Reply-To: <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
 <1214841102.3381.5.camel@localhost.localdomain> <1214925487.3316.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
 <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
 <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-74525993-1222788089=:5818"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-74525993-1222788089=:5818
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 30 Sep 2008, Monty Montgomery wrote:
> > With latest cdparanoia git-^H^H^H^Hsvn, the problem still happens.
> > After applying the patch below, there's no more crash thanks to your last
> > commit, and It Just Works(tm):
> 
> Then I will be doing some headscratching over a copy of the kernel.
> Oh--  what *exact* kernel are you using?  non-x86 trees don't always
> sync often with the 'official' mainline and I want to be sure I'm
> reading the correct thing.  I was a longtime PPC user until about two
> years ago, and I'm used to there being several substantially different
> PPC kernel trees [just making sure].

It happens on anything after 2.6.24 (cfr.
http://bugzilla.kernel.org/show_bug.cgi?id=10974).
E.g. mainline 2.6.27-rc8.

> OTOH, if the kernel isn't even servicing the device as a block device
> until the drive returns a ready status and O_NONBLOCK thwarts waiting
> for that.... sigh.  Nothing like a passthrough interface that still
> isn't a passthrough interface after fifteen years of dicking around.
> 
> I'm not willing to cripple cdparanoia on more-than-one-cdrom systems
> because of an edge case due to yet another ill-considered block layer
> 'feature'.  For one thing *I* need to be able to scan devices without
> blocking on my own multiple drive systems.  If there's a workaround to
> get both, I will find it.
> 
> But it's too early to say for sure.  I'll check again.

The difficult part is who's to blame: Linux commit
38582a62ecd337de4212004c7d4844899dc57890 or cdparanoia?

> (May I ask-- why the hard starting/stopping of the interface?  Power saving?]

Which hard starting/stopping do you mean?

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-74525993-1222788089=:5818--
