Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXAZSuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXAZSuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161174AbXAZSuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:50:51 -0500
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:48502 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161173AbXAZSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:50:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=woMt5mLlgbGPyEPPjSukdOs6P8UKTCjjX1enxb/Gn02hNEeRw867wUaQO0j0obzdBa6/SyirLxxPhOLQsQVhnGeJ/8nmvFXy1HF8SP5vPEdpUYtepw3lrVrypHuvs5cM9SOQeb9jmmoypjHsmsUiNA9FgHaXku4CWMHmp4d3VVM=  ;
X-YMail-OSG: 5g3RDLQVM1nRfXikb5ekw8VbWUTEx.a82sPr4UZWKvdlJ8FLrrAbyYop5apRSoiN81eqT4RThHQkubb1apl2evwognKYWaF48XpQJy3HjcXo525es3Qzfgj74d9wBdHDHYDlOUMI_hRCO8NwF3fVy58ts8mz1QnwooaQRlPnCtDeDxNHlueW8oaf8g--
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] [UML] fix mknod
Date: Fri, 26 Jan 2007 19:49:56 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Jeff Dike <jdike@karaya.com>,
       Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org
References: <20070122201317.GA8594@linuxtv.org> <200701232333.29655.blaisorblade@yahoo.it> <20070124203126.36e78674.akpm@osdl.org>
In-Reply-To: <20070124203126.36e78674.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261949.57042.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 05:31, Andrew Morton wrote:
> On Tue, 23 Jan 2007 23:33:29 +0100
>
> Blaisorblade <blaisorblade@yahoo.it> wrote:
> > On Tuesday 23 January 2007 14:17, Johannes Stezenbach wrote:
> > > On Tue, Jan 23, 2007 at 09:02:30AM +0100, Blaisorblade wrote:
> > > > On Monday 22 January 2007 21:13, Johannes Stezenbach wrote:
> > > > > I was playing with user-mode Linux and found that mknod creates
> > > > > devices node in hostfs with wrong major/minor numbers.
> > > > > The patch below fixes it for me.
> > > >
> > > > Hmpf. Still having this bug on hostfs is quite bad. Thanks for
> > > > reporting.
> >
> > I've now seen - we never fixed this one, we fixed the analogous problem
> > on 'ls' output and friends (in init_inode, which is used in many places).
> >
> > > > It should be hostfs_user.c to take major and minor and to combine
> > > > them correctly - it can use libc's macros.
> > >
> > > Right, below is a better patch.
> >
> > Exactly what I meant, thanks!
> > I'd say:
> > Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> > This can go to 2.6.20, and possibly even to -stable (after either me or
> > Jeff tests it once).

> So..  did you test it?

Just tested, I could reproduce the bug and verify the fix works, on 2.6.18; 
and for me it's enough to merge it, considering that little changes happened 
on hostfs, and because it's well understood with static review that this fix 
is needed.

It should also be merged in 2.6.16-stable.
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
