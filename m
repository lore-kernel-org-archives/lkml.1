Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYCQOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYCQOea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYCQOeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 10:34:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:47406 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbYCQOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:34:20 -0400
Message-ID: <47DE815C.4060906@googlemail.com>
Date: Mon, 17 Mar 2008 15:34:04 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.25-rc6
References: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> Zhang, Rui (2):
>       thermal: fix generic thermal I/F for hwmon

That commit broke lmsensros here ( found by bisect ). 
...

Can't access procfs/sysfs file
Kernel interface access error
For 2.6 kernels, make sure you have mounted sysfs and libsensors
was compiled with sysfs support!

...

Of course proc and sysfs is mounted and the lib has that support :)

Here the bisect result :

git-bisect start
# bad: [a978b30af3bab0dd9af9350eeda25e76123fa28e] Linux 2.6.25-rc6
git-bisect bad a978b30af3bab0dd9af9350eeda25e76123fa28e
# good: [cdeeeae056a429e729ae9e914fa8142ee45bee93] Linux 2.6.25-rc5
git-bisect good cdeeeae056a429e729ae9e914fa8142ee45bee93
# good: [609eb39c8d8a8d2930780428f6cbe2f63eb84734] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect good 609eb39c8d8a8d2930780428f6cbe2f63eb84734
# bad: [b4de123a0bc4a3f0c90899864d51299628729952] Merge branches 'release', 'ejd', 'sony' and 'wmi' into release
git-bisect bad b4de123a0bc4a3f0c90899864d51299628729952
# good: [93d74463d018ddf05c169ad399e62e90e0f82fc0] Merge master.kernel.org:/home/rmk/linux-2.6-arm
git-bisect good 93d74463d018ddf05c169ad399e62e90e0f82fc0
# bad: [160ff06b1848a01913611950b05963e3315f759b] Merge branches 'release' and 'thermal' into release
git-bisect bad 160ff06b1848a01913611950b05963e3315f759b
# good: [1ca721cdb748ba72c47e9c661d54696db3cde796] Merge branches 'release', 'bugzilla-8570', 'bugzilla-9966', 'bugzilla-9998', 'bugzilla-10100', 'bugzilla-10132', 'bugzilla-10138' and 'bugzilla-10206' into release
git-bisect good 1ca721cdb748ba72c47e9c661d54696db3cde796
# bad: [5e012760dfd5ec24c41b9eab9e654a88360bb026] ACPI: thermal: show temperature in millidegree Celsius
git-bisect bad 5e012760dfd5ec24c41b9eab9e654a88360bb026
# bad: [3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9] thermal: fix generic thermal I/F for hwmon
git-bisect bad 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9


3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9 is first bad commit
commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9
Author: Zhang, Rui <rui.zhang@intel.com>
Date:   Wed Feb 27 08:37:50 2008 +0800

    thermal: fix generic thermal I/F for hwmon

    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 24d2abc5c456ab21ecf7b6435acb1759d3246ad5 37cbb30f23bc8177b5eb7a0cfa8fea1ebbf624f6 M      Documentation
:040000 040000 4a99b828c819c76578ea1c0fbdcbbfc046651ec7 747dae53551ad0738d8581623928ddbc1ea19528 M      drivers


Reverting this commit from 2.6.25-rc6 fixes the problem.


Best Regards,

Gabriel
