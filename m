Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZDPLpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZDPLpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZDPLo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:44:56 -0400
Received: from THUNK.ORG ([69.25.196.29]:49125 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZDPLoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:44:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Documentation: Add "how to write a good patch summary" to SubmittingPatches
Date: Thu, 16 Apr 2009 07:44:45 -0400
Message-Id: <1239882285-4994-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately many patch submissions are arriving with painfully poor
patch descriptions.   As a result of the discussion on LKML:

      http://lkml.org/lkml/2009/4/15/296

explain how to submit a better patch description, in the (perhaps
vain) hope that maintainers won't end up having to rewrite the git
commit logs as often as they do today.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>
---

I don't describe the "Impact: " header, since this is still somewhat
controversial.  But even if we don't end up standardizing on Impact:,
there is good information that we should be telling people about.

Also, SubmittingPatches is getting quite long.  It probably needs to be
split up into a couple of different files, or at least reorganized for
easier reading.  It's not clear to me that trying to explain how to
develop a good patch, how to write a good patch submission, and issues
around the Developers Certification of Origin should be smushed together
all into a single documentation file.  But, that reorg is for another
day and another patch.

 Documentation/SubmittingPatches |   65 ++++++++++++++++++++++++++++++--------
 1 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index f309d3c..b6f463f 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -91,6 +91,10 @@ Be as specific as possible.  The WORST descriptions possible include
 things like "update driver X", "bug fix for driver X", or "this patch
 includes updates for subsystem X.  Please apply."
 
+The maintainer will thank you if you write your patch description in a
+form which can be easily pulled into Linux's source code management
+system, git, as a "commit log".  See #15, below.
+
 If your description starts to get long, that's a sign that you probably
 need to split up your patch.  See #3, next.
 
@@ -485,12 +489,33 @@ phrase" should not be a filename.  Do not use the same "summary
 phrase" for every patch in a whole patch series (where a "patch
 series" is an ordered sequence of multiple, related patches).
 
-Bear in mind that the "summary phrase" of your email becomes
-a globally-unique identifier for that patch.  It propagates
-all the way into the git changelog.  The "summary phrase" may
-later be used in developer discussions which refer to the patch.
-People will want to google for the "summary phrase" to read
-discussion regarding that patch.
+Bear in mind that the "summary phrase" of your email becomes a
+globally-unique identifier for that patch.  It propagates all the way
+into the git changelog.  The "summary phrase" may later be used in
+developer discussions which refer to the patch.  People will want to
+google for the "summary phrase" to read discussion regarding that
+patch.  It will also be the only thing that people may quickly see
+when, two or three months later, they are going through perhaps
+thousands of patches using tools such as "gitk" or "git log
+--oneline".
+
+For these reasons, the "summary" must be no more than 70-75
+characters, and it must describe both what the patch changes, as well
+as why the patch might be necessary.  It is challenging to be both
+succinct and descriptive, but that is what a well-written summary
+should do.
+
+The "summary phrase" may be prefixed by tags enclosed in square
+brackets: "Subject: [PATCH tag] <summary phrase>".  The tags are not
+considered part of the summary phrase, but describe how the patch
+should be treated.  Common tags might include a version descriptor if
+the multiple versions of the patch have been sent out in response to
+comments (i.e., "v1, v2, v3"), or "RFC" to indicate a request for
+comments.  If there are four patches in a patch series the individual
+patches may be numbered like this: 1/4, 2/4, 3/4, 4/4.  This assures
+that developers understand the order in which the patches should be
+applied and that they have reviewed or applied all of the patches in
+the patch series.
 
 A couple of example Subjects:
 
@@ -510,19 +535,31 @@ the patch author in the changelog.
 The explanation body will be committed to the permanent source
 changelog, so should make sense to a competent reader who has long
 since forgotten the immediate details of the discussion that might
-have led to this patch.
+have led to this patch.  Including symptoms of the failure which the
+patch addresses (kernel log messages, oops messages, etc.) is
+especially useful for people who might be searching the commit logs
+looking for the applicable patch.  If a patch fixes a compile failure,
+it may not be necessary to include _all_ of the compile failures; just
+enough that it is likely that someone searching for the patch can find
+it.  As in the "summary phrase", it is important to be both succinct as
+well as descriptive.
 
 The "---" marker line serves the essential purpose of marking for patch
 handling tools where the changelog message ends.
 
 One good use for the additional comments after the "---" marker is for
-a diffstat, to show what files have changed, and the number of inserted
-and deleted lines per file.  A diffstat is especially useful on bigger
-patches.  Other comments relevant only to the moment or the maintainer,
-not suitable for the permanent changelog, should also go here.
-Use diffstat options "-p 1 -w 70" so that filenames are listed from the
-top of the kernel source tree and don't use too much horizontal space
-(easily fit in 80 columns, maybe with some indentation).
+a diffstat, to show what files have changed, and the number of
+inserted and deleted lines per file.  A diffstat is especially useful
+on bigger patches.  Other comments relevant only to the moment or the
+maintainer, not suitable for the permanent changelog, should also go
+here.  A good example of such comments might be "patch changelogs"
+which describe what has changed between the v1 and v2 version of the
+patch.
+
+If you are going to include a diffstat after the "---" marker, please
+use diffstat options "-p 1 -w 70" so that filenames are listed from
+the top of the kernel source tree and don't use too much horizontal
+space (easily fit in 80 columns, maybe with some indentation).
 
 See more details on the proper patch format in the following
 references.
-- 
1.5.6.3

