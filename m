Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXEQVCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXEQVCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQVBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:01:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbXEQVBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:01:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [PATCH] LogFS take three
Date: Thu, 17 May 2007 23:00:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
References: <20070515151919.GA32510@lazybastard.org> <200705171708.53038.arnd@arndb.de> <20070517202139.GD15676@lazybastard.org>
In-Reply-To: <20070517202139.GD15676@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705172300.21694.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19qMrsrIix5XKZdLGfe+SjJUTH34tbehG0xV8L
 Ah3dEeNd8BLAT9hfxCacgBR1zA8//3xP21Ju9rZqQ0u++iO8wi
 TfNl+OH9VuQFdWFt3ItHA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007, Jörn Engel wrote:
> 
> > Why not just store 64 bit nanoseconds? that would avoid the problem
> > with ns overflow and the year-2038 bug. OTOH, that would require
> > a 64 bit integer division when reading the data, so it gets you
> > a runtime overhead.
> 
> I like the idea.  Do conversion function exist both way?
> 
> What I don't get is the year-2038 bug.  Isn't that the 31bit limit,
> while 32bit would last to 2106?

You're right, you don't hit the 2038 bug here, because you use an
unsigned variable. The bug exists elsewhere because time_t tv_sec
is signed.

Just using nanoseconds probably doesn't gain you much after all
then. You could however just have separate 32 bit fields in the
inode for seconds and nanoseconds, that will result in the exact
same layout that you have right now, but won't require a conversion
function.

	Arnd <><
