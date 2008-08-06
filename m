Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYHFWUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYHFWUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYHFWTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:19:52 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:42389 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbYHFWTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:19:50 -0400
Date: Thu, 7 Aug 2008 00:19:40 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: =?ISO-8859-2?Q?Piotr_Jaroszy=F1ski?= <p.jaroszynski@gmail.com>
cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org
Subject: Re: HZ from userspace
In-Reply-To: <d77765540808061507v47561931x23a23c30067bc57b@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0808070010260.5671@titan.stealer.net>
References: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>  <2c0942db0808061449s48ba235cy1b5672c0952b8fdf@mail.gmail.com> <d77765540808061507v47561931x23a23c30067bc57b@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-967258400-1015051523-1218061106=:5671"
Content-ID: <alpine.LNX.1.10.0808070019170.5671@titan.stealer.net>
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 06 Aug 2008 22:19:48 +0000
	Bayes: 0.3155 Tokens: new, 172; hammy, 1; neutral, 4; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3155]
X-Spam-Signature: 0e33f40b0e2c8022c7536f3fe94c2a873746b5da
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---967258400-1015051523-1218061106=:5671
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LNX.1.10.0808070019171.5671@titan.stealer.net>

On Wed, 6 Aug 2008, Piotr Jaroszy=F1ski wrote:

> >> I want to be able to convert starttime from /proc/#/stat to absolute
> >> time and it seems that I need HZ to do that as it is measured in
> >> jiffies. How can I get HZ? I have seen some discussion about this but
> >> haven't found a definite answer. procps is using some hacks do it and
> >> I would prefer to avoid them.
> >> I only need a solution for modern kernels, say 2.6.20+ if that matters=
=2E
> >
> > `man sysconf`, in particular you want sysconf(_SC_CLK_TCK).
>=20
> manpage says it's obsolete and i read in some discussion that it only
> returns the default and not the real HZ used.

You can get the information via two ways. At compile time, that is the=20
variable CLK_TCK and this way has been obsoleted. The other way is at=20
runtime via sysconf(_SC_CLK_TCK) and that is still valid. You don't need=20
the real HZ, because the kernel converts it to USER_HZ, which is currently=
=20
100 on x86 for historic reasons.

Sven
---967258400-1015051523-1218061106=:5671--
