Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbXEQVg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbXEQVg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXEQVgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:36:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbXEQVgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:36:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] LogFS take three
Date: Thu, 17 May 2007 23:36:13 +0200
User-Agent: KMail/1.9.6
Cc: "=?utf-8?q?J=C3=B6rn?= Engel" <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
References: <20070515151919.GA32510@lazybastard.org> <20070516132035.GJ5472@lazybastard.org> <464CC209.4060500@cs.helsinki.fi>
In-Reply-To: <464CC209.4060500@cs.helsinki.fi>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705172336.14552.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/bWzf1bYN5U4rh6FyWYF/WSb2AGkRRzyh/NB4
 jwP2gUKr5Yk0ex8ECEA7GqmDhQq9k0xAtGYml+9t3EbSsks1v4
 MrEL8gW7FAsD8/pQdU5Jg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007, Pekka Enberg wrote:
> 
> Jörn Engel wrote:
> > Compressing random data will actually enlarge it.  If that happens I
> > simply store the verbatim uncompressed data instead and mark it as such.
> > 
> > There is also demand for a user-controlled bit in the inode to disable
> > compression completely.  All those .jpg, .mpg, .mp3, etc. just waste
> > time by trying and failing to compress them.
> 
> So any sane way to enable compression is on per-inode basis which makes 
> me still wonder why you need per-object compression.

1. it doesn't require user interaction, the file system will do the right
thing most of the time.

2. enlarging data is a very bad thing because it makes the behaviour
of the fs unpredictable. With uncompressed objects, you have a guaranteed
upper bound on the size.

	Arnd <><
