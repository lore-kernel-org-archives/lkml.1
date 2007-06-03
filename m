Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXFCWTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXFCWTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXFCWSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:18:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbXFCWSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:18:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: LogFS take four
Date: Mon, 4 Jun 2007 00:18:21 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
References: <20070603183845.GA8952@lazybastard.org>
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706040018.23001.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/C0JqKomt+Kryy2EdTSuLhiDI447eVhCohsVw
 kgx4o9LAIvP7NBCKk80XG1T2reF4CYp6LvYYvBL6kJp1MdVSI0
 JeALKhjiTewo6Vk7oySgQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 June 2007, Jörn Engel wrote:

> Unchanged:
> o error handling
> 
...
> Won't happen (unless I get convinced to do otherwise):
> o Change LOGFS_BUG() and LOGFS_BUG_ON() to inline functions
>   These are macros for very much the same reasons BUG() and BUG_ON() are.

I wonder how many of your LOGFS_BUG{,_ON} still remain after the
error handling is in place to deal with broken file system contents.
Ideally, I'd say the current LOGFS_BUG() should be replaced with
a function that prints about the kind of error it has hit (rate-limited),
potentially calls logfs_crash_dump(), and remounts the medium read-only,
but _not_ call BUG().

	Arnd <><
