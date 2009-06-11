Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbZFKIKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbZFKIKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZFKIKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:10:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34040 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795AbZFKIKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:10:17 -0400
Date: Thu, 11 Jun 2009 10:10:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611081012.GD8592@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-10 10:43:53, Brian Swetland wrote:
> On Wed, Jun 10, 2009 at 3:31 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > Hi!
> >
> > Is there patch for Dream support for 2.6.30 somewhere? The best I
> > could find is linux-msm tree, which is ... quite a big diff against
> > 2.6.24:
> 
> Our current working tree (for the donut branch) is against 2.6.29:
> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
> 

Strange, I attempted downloading this overnight (285MB!) by 

git clone  --template=/data/l/clean-cg/ git://android.git.kernel.org/kernel/msm.git

....and got 2.6.27 sources. Aha, 

git checkout -b android-msm-2.6.29 origin/android-msm-2.6.29

Helped. Thanks!

> The cupcake/1.5 system update (latest production kernel) was against 2.6.27:
> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.27
> 
> > Is all of it neccessary for dream or are parts such as board-halibut
> > parts of some other support? Do I have wrong tree entirely?
> 
> Most of it is necessary.  board-halibut is a qualcomm reference
> design.  board-sapphire is HTC Magic.  board-trout is G1/ADP1.
> arch/arm/config/msm_defconfig is how we configure the kernel we ship
> which supports all three.

Ok, could we get the boards renamed? g1 is known as dream, having
trout+dream+g1+adp1 names for same piece of hardware is unnice.

Hmm, perhaps this would be useful to apply?

---

Inform people about board codenames, and add how-to download latest
sources.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/android.txt b/Documentation/android.txt
index 72a62af..a2ad1dc 100644
--- a/Documentation/android.txt
+++ b/Documentation/android.txt
@@ -14,6 +14,13 @@ CONTENTS:
   1.3 Recommended enabled config options
 2. Contact
 
+0. Getting sources:
+-----------------
+
+git clone  --template=/path/to/linux-git/for/speedup/ git://android.git.kernel.org/kernel/msm.git
+git checkout -b android-msm-2.6.29 origin/android-msm-2.6.29
+
+(280MB+ download!)
 
 1. Android
 ==========
@@ -26,6 +33,8 @@ To see a working defconfig look at msm_defconfig or goldfish_defconfig
 which can be found at http://android.git.kernel.org in kernel/common.git
 and kernel/msm.git
 
+msm_defconfig should work on qualcomm reference design, HTC Magic and G1/ADP1.
+
 
 1.1 Required enabled config options
 -----------------------------------
@@ -113,6 +122,14 @@ LOG_BUF_SHIFT=17
 SERIAL_CORE
 SERIAL_CORE_CONSOLE
 
+1.4 Board code names
+
+board-halibut is a qualcomm reference design.  board-sapphire is HTC
+Magic.  board-trout is G1/ADP1.
+
+
+
+
 
 2. Contact
 ==========


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
