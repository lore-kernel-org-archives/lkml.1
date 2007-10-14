Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbXJNW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbXJNW2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXJNW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:28:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbXJNW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:28:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Hook compat_sys_nanosleep up to high res timer code
Date: Mon, 15 Oct 2007 00:28:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anton Blanchard <anton@samba.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
References: <20071014215437.GF26693@kryten>
In-Reply-To: <20071014215437.GF26693@kryten>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710150028.06493.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/IKpOICjESAfXDR85c4vL7xekZ0rntGZLh4K6
 QMyJn96LeOWFNja4+I2uMhqvf3d+2D9Qs5qnds+JJ/bnlCul6E
 4DkaNlTTsbo+QkprCXaag==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Anton Blanchard wrote:
> Now we have high res timers on ppc64 I thought Id test them. It turns
> out compat_sys_nanosleep hasnt been converted to the hrtimer code and so
> is limited to HZ resolution.
> 
> The following patch makes compat_sys_nanosleep call hrtimer_nanosleep
> and uses compat_alloc_user_space to avoid setting KERNEL_DS.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

The code looks correct, but I think it would be nicer to change 
hrtimer_nanosleep to take a kernel pointer and have all three
callers (common_nsleep, sys_nanosleep and compat_sys_nanosleep)
do the copy_to_user/put_compat_timespec in the caller.

This would also make it possible to get rid of set_fs() in
compat_sys_clock_nanosleep().

	Arnd <><
