Return-Path: <linux-kernel-owner+w=401wt.eu-S1422806AbXBIAXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422806AbXBIAXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXBIAXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:23:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46822 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422806AbXBIAXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:23:12 -0500
Date: Thu, 8 Feb 2007 16:22:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=B3n?= <jamagallon@ono.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <20070209010317.3c442240@werewolf-wl>
Message-ID: <Pine.LNX.4.64.0702081619500.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <20070209010317.3c442240@werewolf-wl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1135479423-1170980579=:8424"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1135479423-1170980579=:8424
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Fri, 9 Feb 2007, J.A. MagallÃ³n wrote:
> 
> Thats the point. Mmmm, I think I see it the other way around. I defined
> a variable as 'signed' or 'unsigned', because the sign info matters for me.
> And gcc warns about using a function on it that will _ignore_ or even
> misinterpret that info. Could it be a BUG ? Yes.

Sure. The other way of seeing it is that *anything*  could be a bug.

Could adding 1 to "a" be a bug? Yes. "a" might overflow. So maybe the 
compiler should warn about that too?

So do you think a compiler should warn when you do

	int a = i + 1;

and say "warning: Expression on line x might overflow"?

Could it be a BUG? Hell yeah.

Is warning for things that _could_ be bugs sane? Hell NO.

> Linux/x86, gcc 4.1.2-0.20070115:
> werewolf:~> gcc -Wpointer-sign -c t.c
> t.c: In function ÿÿfÿÿ:
> t.c:10: warning: pointer targets in passing argument 1 of ÿÿstrlenÿÿ differ in signedness
> t.c:11: warning: pointer targets in passing argument 1 of ÿÿstrlenÿÿ differ in signedness

Yeah, and that's what I think is crazy.

Is it consistent? Yes. Does it help people? No.

A warning that is consistent is not necessarily a good warning. It needs 
to MAKE SENSE too. And this one doesn't.  I'm sorry if you can't see that.

		Linus
---1463790079-1135479423-1170980579=:8424--
