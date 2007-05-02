Return-Path: <linux-kernel-owner+w=401wt.eu-S2993053AbXEBMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993053AbXEBMER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993054AbXEBMER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:04:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:60538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2993053AbXEBMEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:04:15 -0400
Cc: abraham.manu@gmail.com, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org, mchehab@infradead.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 02 May 2007 14:04:14 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <Pine.LNX.4.58.0705020348080.309@shell2.speakeasy.net>
Message-ID: <20070502120414.80840@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com> 
	<1178031333.3958.63.camel@localhost>
	<Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
	<1178071431.11109.62.camel@localhost>
 <Pine.LNX.4.58.0705020348080.309@shell2.speakeasy.net>
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was:	Critical
	points about ...)
To: Trent Piepho <xyzzy@speakeasy.org>, mchehab@infradead.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19zSSZLADVz7QP0+uob8KR1bRCj/P42/UmwPzrCdm
 syWCEnDlfsv5jS+8b/BRgqEKKYFqYYdHgfTw== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: B0YOD9xYQEV/GzO4FnVp2zdCNzg2NYL5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Wed, 2 May 2007 04:10:03 -0700 (PDT)
Von: Trent Piepho <xyzzy@speakeasy.org>
An: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Betreff: Re: [linux-dvb] Re: DST/BT878 module customization (.. was:	Critical	points about ...)

> On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> > Em Ter, 2007-05-01 Ã s 16:16 -0700, Trent Piepho escreveu:
> > > On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> > > > With this configuration, dvb-bt8xx hangs during initialization,
> > > > generating an OOPS, if you have a board with DST (modprobe dvb-bt8xx
> > > > never returns).
> > >
> > > Stupid typo in the first patch, a != should have been ==.
> > >
> > > Fixed:
> > > http://linuxtv.org/hg/~tap/dst-new
> >
> > With the changes, the dst unselection worked.
> >
> > Those are the logs with dst unselected:
> >
> > DVB: registering new adapter (bttv0).
> > DVB: Unable to find symbol dst_attach()
> > frontend_init: Could not find a Twinhan DST.
> > dvb-bt8xx: A frontend driver was not found for device 109e/0878
> subsystem fbfb/f800
> 
> This is the dvb_attach() "not found" message.  You should see this same
> message if you leave dst selected and then just delete the dst modules
> before
> loading dvb-bt8xx.
> 
> If you turn dvb_attach off, you should see a different "dst support was
> disabled" message (and no crash!).
> 
> > However, when dst is selected, I got those errors:
> 
> When I made this patch I was basing it off a patch I made around 9 months
> ago.  I thought since that one was ok, this would be ok too, and in my
> hurry to get it done I've clearly put too little effort into checking it,
> and I'm sorry to have wasted your time.
> 
> I promise, this time it's right!
> http://linuxtv.org/hg/~tap/dst-new

The DST card with CA slot and the DST card without CA slot are two different cases.
Like the Pinnacle PCTV SAT with CI extension and the Pinnacle PCTV SAT without CI extension.

In so far my questions are:
Shouldn't there be two cases for deselecting DST modules?
At least my basic approach tried to distinct those two cases.
In how far is it enough or technically sufficient to treat those two cases as one?

And, as already mentioned: At least in all of those 4 cases no dvb-pll module
isn't needed at all - someone simply forgot to add some lines for the exception handling in dvb-bt8xx to get rid of dvb-pll.c if there is no lgdt330x frontend needed (read: if there is no Fusion HDTV Lite card in the machine at all).

If this small case is being fixed you simply can expand the deselection of dvb-pll.c
on all cards treated in backend module dvb-bt8xx.c.

Uwe

> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
