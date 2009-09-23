Return-Path: <linux-kernel-owner+w=401wt.eu-S1751194AbZIWN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbZIWN02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZIWN01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:26:27 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:42881 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZIWN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:26:26 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 09:26:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=hxaYn0c1bm4rcIgUFOz2Qc5x3nRo7EzMuZsnSjQRBY1dizvRKA7jCqfAuS6zEVe7pn
         i1vQJRzLZKRugtJiZGCS0vR+n2zLHvCsvcPJxzBqIyO95h2Ymvr7hNwn4kELXEWBz1pl
         f4Q+2eCCkY3+bxCs8KbofaG+RLSUdA7lumTQo=
Message-ID: <4ABA20B8.2000008@gmail.com>
Date: Wed, 23 Sep 2009 21:20:56 +0800
From: Wang Chen <ellre923@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
CC: Wang Chen <wangchen@cn.fujitsu.com>
Subject: [QA Process] Kernel Defects Before and After Release
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HTML Page: http://www.remword.com/blog/?p=210
---------
I¡¯ve tried to analyze the defect data of Linux Kernel to find out the answers of the following questions.

1. How much effort the release candidate period should give?

2. Does the quality of stable kernel(stable kernel without update) becomes better or worse?

To figure out the questions, I gathered the following datum.

1. Pre-RC Changed Lines: The lines of source code changed between 2.6.(n-1) and 2.6.n-rc1. These source codes are confluxed during merge window period of each version of kernel. They are mostly implemented for new features of a new version of kernel, which needs a long period of testing and fixing after merge window closes.

2. Defects found during RC: Because mainline almost only accepts bug fix patches in RC period and we encourage one patch per bug, the patch set quantity of RC approximately represents quantity of defects found in RC period, which we call internal(inside development community) testing period. This data comes from git-log between 2.6.n-rc1 and 2.6.n.

3. Defects found after release: After stable kernel release, users and developers themselves will find some bugs and fix them. To eliminate the unfair caused by different release time, I only collect the stable kernel defects which was fixed before next 2.6.x stable release. For example, if 2.6.n was released on 2009.A.B and 2.6.(n+1) was released on 2009.C.D, the ¡°Defects found after release¡± means the fixes for 2.6.n stable kernel before 2009.C.D. Actually, I dig the data from GregKH¡¯s stable git trees.

By putting the RC defect ratio(¡±Defects found during RC¡±/¡±Pre-RC Changed Lines¡±[kstep]) to X-axis and Stable defect ratio(¡±Defects found after release¡±/¡±Pre-RC Changed Lines¡±[kstep]) to Y-axis, I got some interesting graphics here.

Wait¡­ What do you expect to see? More RC fix bring higher quality of stable kernel?

1. Picture-1 maybe disappoints you. We see here: the more bugs got killed during RC the more complaint from stable users or developers.  Why? I don¡¯t remember who said this, but I remember these words ¡°Finding MORE defects means as MORE defects unrevealed¡±. RC defect rate doesn¡¯t mean that the more bugs fixed the higher quality of release. Instead it tells us whether new features have a trustful quality before being sent into merge window. Developers should well test their patches of new feature as well as the patches for RC. So here comes another question: we can¡¯t keep doing RC forever, thus when should we stop RC and goto release.
[Picture-1: http://www.remword.com/blog/wp-content/uploads/2009/09/whole.PNG]

2. Picture-2 shows that RC fixing increased nearly as linear trend according to different Pre-RC code quantity. But trend is trend, some kernel releases didn¡¯t have enough defects be found during RC and some had above-average RC defects ratio. Let¡¯s go back to Picture-1, we can see densest RC defect ratio region is about 2.5-3.0 defect/kstep, and the average RC defect ratio is about 2.87 defect/kstep, which is marked by the red ordinate. Below the average RC defect ratio, four of ten releases have above-average stable defect ratio. If we set a rule to not allow ending RC when the RC defect ratio is still below average, we can make ¡°the four¡± releases more stable.

Now we have seen two pictures of whole kernel defect ratio, but how about subsystems?
[Picture-2: http://www.remword.com/blog/wp-content/uploads/2009/09/rc_patch.PNG]

3. Not only whole kernel should have a RC defect ratio gate, each subsystem also should not allow too low RC defect ratio. Let¡¯s see some.

Network subsystem is almost like whole kernel, stable defect ratio increases as RC defect ratio increasing. ¡°core kernel¡±, ¡°fs¡±, ¡°arch¡± and ¡°block¡± are almost as same, which I don¡¯t paste here to save my host¡¯s space ;)
[http://www.remword.com/blog/wp-content/uploads/2009/09/net.PNG]

Sound subsystem is some kind of strange.  When RC defect ratio exceeds 3.0 defect/kstep, stable defect ratio begins to descend. In my superficial opinion: very strong RC effort(seven times of average) causes higher stable quality. At this point, very high RC defect ratio no longer means ¡°Finding MORE defects means as MORE defects unrevealed¡±, but means ¡°Highly quality control reduces unrevealed defects¡±.
[http://www.remword.com/blog/wp-content/uploads/2009/09/sound.PNG]

Memory Management looks like an ideal descending trend, if we ignore 2.6.16, 2.6.20 and 2.6.21. In mm, RC defect ratio is very higher than any other subsystems, because mm is essential part of core kernel and rarely changes.  I don¡¯t recall what happened on the three releases, maybe something like virtualization supporting can cause such a defect boom.
[http://www.remword.com/blog/wp-content/uploads/2009/09/mm.PNG]

4. This is the last graph which answers my question about ¡°Does the quality of stable kernel becomes better or worse?¡±. From 2.6.14 to 2.6.30, stable kernel has an average defect ratio about 0.32 defect/kstep. Since 2.6.23, kernel tends to keep a lower stable defect ratio, although 2.6.27 and 2.6.28 departed from the trend. I¡¯d like to say maybe we are releasing kernels of better quality.
[http://www.remword.com/blog/wp-content/uploads/2009/09/stable.PNG]

As Linus said at Linuxconf this week :¡±Linux is bloated¡°,  it doesn¡¯t only means that kernel got bigger and bigger, but also means that kernel grows up faster and faster. So when to release a new kernel not only depends on time and RC rounds, but also depends on defect ratio and new feature's influence scope.

--
Wang Chen
