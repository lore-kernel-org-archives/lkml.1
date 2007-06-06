Return-Path: <linux-kernel-owner+w=401wt.eu-S934062AbXFFMm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062AbXFFMm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761469AbXFFMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:42:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:52878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXFFMms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:42:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Patch 04/18] include/linux/logfs.h
Date: Wed, 6 Jun 2007 14:42:29 +0200
User-Agent: KMail/1.9.6
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, John Stoffel <john@stoffel.org>,
       Willy Tarreau <w@1wt.eu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       CaT <cat@zip.com.au>, Ondrej Zajicek <santiago@crfreenet.org>,
       linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>, Dongjun Shin <djshin90@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Albert Cahalan <acahalan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>,
       =?iso-8859-15?q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Pavel Machek <pavel@ucw.cz>, Ulisses Furquim <ulissesf@gmail.com>,
       akpm@osdl.org, David Weinehall <tao@acc.umu.se>
References: <20070603183845.GA8952@lazybastard.org> <db91817d295770e459727005108b05e2@kernel.crashing.org> <1181119820.25232.434.camel@pmac.infradead.org>
In-Reply-To: <1181119820.25232.434.camel@pmac.infradead.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706061442.31147.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19b31Ty6sZ8tZlEzIMhB72KlwHgCjw6ToqQx8G
 asJ1BbzpplHPi8r3bluFdHdkswBkndd6z+88wWO5jPK11zfvn8
 RmhhXZm2YFHJX9J8u14rQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007, David Woodhouse wrote:
> And if I had something like this (which is admittedly contrived, but
> hardware people _do_ do stupid things to us):
>    { uint32_t, uint8_t, uint16_t, uint8_t, uint32_t, uint32_t }
> 
> With the 'packed' attribute the compiler would assume arbitrary
> alignment of all the 32-bit integers. But in reality it's only necessary
> for the uint16_t in the middle. A 'nopadding' attribute would deal with
> that correctly.

I would argue that a newly invented 'nopadding' attribute should reject
such a structure as invalid, because it should not let members be
unaligned. Unfortunately, this also gets tricky if you consider

struct {
	uint32_t a;
	uint64_t b;
	uint32_t c;
};

which does have an unaligned member by default in i386, but not on
any modern platform.

	Arnd <><
