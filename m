Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXCTVUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXCTVUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXCTVUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:20:01 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49228 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbXCTVUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:20:00 -0400
Date: Tue, 20 Mar 2007 22:16:35 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: kconfig `bool' (was: Re: [PATCH 13/13] fix ps3fb glue allowing
 a modular build)
In-Reply-To: <Pine.LNX.4.62.0703202148150.22113@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.61.0703202213130.20032@yvahk01.tjqt.qr>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
 <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
 <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
 <20070314170720.GL4095@ftp.linux.org.uk> <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
 <Pine.LNX.4.62.0703202148150.22113@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 20 2007 22:06, Geert Uytterhoeven wrote:
>> 
>> Maybe not "bool" vs "mbool", but it might be nice to have
>> 
>> 	bool FB_PS3
>> 		depends strictly on FB
>> 
>> ie a "depends strictly" refuses to upgrade a bool dependency from "m" to 
>> "y", while a regular depends allows it.
>> 
>> Or something.. The "depends strictly on X" thing would really be just a 
>> mental shorthand for "depends on (X)=y" (it's actually longer to type, but 
>> I think it's a bit more intuitive, thus "mental shortcut").
>
>I've been thinking about this a bit more...
>
>Kconfig knows about the following types:
>  o bool
>  o tristate
>  o string
>  o hex
>  o int
>
>However, from a semantical point of view, they can be subdivided in 2 classes:
>  1. driver/subsystem/library enablers (i.e. things that are used in a Makefile
>     to decide whether to compile a unit or not):
>       o tristate (y=builtin, m=loadable, n=disabled)
>       o bool (y=builtin, n=disabled)
>  2. options (i.e. things that control some features, limits, or default
>     values):
>       o bool (y=true, n=false)
>       o string (literal)
>       o hex (literal)
>       o int (literal)
>
>The confusion arises from the 2 different semantics for `bool': for the former,
>a `depends on' obviously cannot be `builtin' if the dependency is `modular',
>while for the latter, it can be `true' if the dependency is `modular'.

I think it was once (is still?) possible to have something like

  <M> Foo
      <*> Bar

which would mean: include bar.o into foo.ko. If one chose to

  <M> Foo
      <M> Bar

you'd get foo.ko and bar.ko, with a modinfo dependency of course.



Jan
-- 
