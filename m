Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYHUIUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYHUIUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYHUITl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:19:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYHUITi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:19:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Date: Thu, 21 Aug 2008 10:14:42 +0200
User-Agent: KMail/1.9.9
Cc: Paul Mackerras <paulus@samba.org>, Robert Richter <robert.richter@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808201519.19453.arnd@arndb.de> <18604.60738.523963.886786@drongo.ozlabs.ibm.com>
In-Reply-To: <18604.60738.523963.886786@drongo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211014.42683.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19vxHhfWHFZcp0K2nNhMO0yV5Of2785tHPONKe
 jQ1q3NVd3k018uxYqoKtgwORYtJxL2aDe4fH+cuTjB4trkANG1
 S8H60UybdqUCqulqZzaAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Paul Mackerras wrote:
> Arnd Bergmann writes:
> 
> > Paul, any chance we can still get this into 2.6.27?
> 
> Possibly.  We'll need a really good explanation for Linus as to why
> this is needed (what regression or serious bug this fixes) and why it
> is late.  Can you send me something explaining that?

The patch does not fix a regression, the spu-oprofile code basically never
worked. With the current code in Linux, samples in the profile buffer
can get corrupted because reader and writer to that buffer use different
locks for accessing it. It took us several iterations to come up with
a solution that does not introduce other problems and I didn't want to
push an earlier version that would need more fixups.

Since rc4 is out now, I understand if you feel more comfortable with
putting the patch into -next instead of -merge.
Note that the second patch is trivial and fixes an oopsable condition
of the kernel, so at least that should still go into 2.6.27.

> > I've added the Ack and uploaded it again for you to
> > pull from
> > 
> >  master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge
> 
> Are you sure you actually managed to update that?

No, but it's there now. I was missing the '-f' for git-push.

	Arnd <><
