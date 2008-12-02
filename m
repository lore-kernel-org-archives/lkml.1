Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYLBStW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYLBStW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYLBStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:49:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:56103 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYLBStM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:49:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=XeW3TMMGubfDv9CarB8Z2Rpm1lvvuXJMpmahnFauS9RMZM+USM9K2dva64ecrKar4d
         GH15+tSd90kPqZWHtqpoIIpEE595rQJFpRuiEgzrOmGDjmfFElyj5wAQyCJvBUrqE2/+
         5QyU+xOqLtpbg13z1aGtyyTFFLClWoQYd4jws=
Date: Tue, 2 Dec 2008 19:49:07 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       "Michael B. Trausch" <mike@trausch.us>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202194907.4eaffc0a@varda>
In-Reply-To: <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131442.42e7df48@varda>
	<alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org>
	<20081202165637.09984819@varda>
	<alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 08:13:47 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 
> 
> On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:

[ ... ]
> 
> Since you are apparently a git user, and 2.6.28-rc6-00007-ged31348 was 
> fine, there's really only 270 commits in between that and 2.6.28-rc7. Can 
> I ask you to bisect for a couple of runs, which would cut it down to a 
> handful? (Ie you don't even need to do a full bisect, although that should 
> really only require about 8 reboots).
> 
> Just do
> 
> 	git bisect start
> 	git bisect bad v2.6.27
                       v2.6.28-rc7 <<< 
> 	git bisect good v2.6.28-rc6-00007-ged31348
> 
> and off you go. That would help enormously.
> 
> There are very few console-related changes in that range, and the most 
> notably one is actually radeon-specific so it shouldn't be an issue for 
> you. I'd _suspect_ bca404afdc5206c3bb30168315ee8a98a579ec65 ("fbdev: fix 
> FB console blanking"), but quite frankly, it could be something random 
> that just interacted badly. A bisection would narrow things down.

 Here you go 

 [alex@varda:kernel/linux-2.6]$ git bisect bad                                   
31168481c32c8a485e1003af9433124dede57f8d is first bad commit
commit 31168481c32c8a485e1003af9433124dede57f8d
Author: Al Viro <viro@ftp.linux.org.uk>
Date:   Sat Nov 22 17:33:24 2008 +0000

    meminit section warnings
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 87b37c3148067870af9fd13e661e0dc96ddfb99c b971fe6efa622c1f90ef7da702997a04fc83418d M      include
:040000 040000 6dc7c5088a129e3432c31aadce83e98c2e07916e ae9694713cee3ff50411102b08fb4f33f881f3c4 M      mm



[alex@varda:kernel/linux-2.6]$ git bisect log

git bisect start
# bad: [061e41fdb5047b1fb161e89664057835935ca1d2] Linux 2.6.28-rc7
git bisect bad 061e41fdb5047b1fb161e89664057835935ca1d2
# good: [ed313489badef16d700f5a3be50e8fd8f8294bc8] Merge master.kernel.org:/home/rmk/linux-2.6-arm
git bisect good ed313489badef16d700f5a3be50e8fd8f8294bc8
# bad: [9bd062d9eaf9e790330f37d9f4518e1b95131f6c] Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 9bd062d9eaf9e790330f37d9f4518e1b95131f6c
# bad: [499c59c42967329d39481314a839d7669f5e1506] MN10300: Tighten up the code using case ranges
git bisect bad 499c59c42967329d39481314a839d7669f5e1506
# bad: [211f05a034f49586fdd071abd174853217ec29ee] input: replace spin_lock_bh with spin_lock_irqsave in ml_ff_playback
git bisect bad 211f05a034f49586fdd071abd174853217ec29ee
# bad: [1c4567aeed84a2746d78d4c1fe092222a559d43f] m32r: section noise in head.S
git bisect bad 1c4567aeed84a2746d78d4c1fe092222a559d43f
# bad: [d16d7667f9c211e8d9b7e2365cc3d3a83fc6a8e2] icside section warnings
git bisect bad d16d7667f9c211e8d9b7e2365cc3d3a83fc6a8e2
# bad: [409832f5484cd1e2d8812c3236dffb33d01c359b] sparc32 cpuinit flase positives
git bisect bad 409832f5484cd1e2d8812c3236dffb33d01c359b
# bad: [7d6a8a1c487422b772201927c454930377d8cf7e] false __cpuinit positives on alpha
git bisect bad 7d6a8a1c487422b772201927c454930377d8cf7e
# bad: [31168481c32c8a485e1003af9433124dede57f8d] meminit section warnings
git bisect bad 31168481c32c8a485e1003af9433124dede57f8d


 That's what i got after the bisection dunno if that helps...


> 
> 			Linus
