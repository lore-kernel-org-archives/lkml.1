Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbYDINOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbYDINOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDINOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:14:11 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3696 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYDINOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:14:09 -0400
Date: Wed, 9 Apr 2008 14:14:20 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080409131420.GL17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org> <20080409081943.GI17915@shadowen.org> <20080409083013.GJ17915@shadowen.org> <20080409084606.GD19010@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409084606.GD19010@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 10:46:06AM +0200, Andi Kleen wrote:
> > Oh, and if people felt that the concensus was for something to be
> > implemented and that you are waiting for me to implement the change in
> > checkpatch; please say so.
> 
> Well at least I think the printk change is a good one to implement and there 
> wasn't much protest to it at least.

Ok.  will put this on my todo list.

> If you're looking for another change request I think dropping the trailing
> white space check would be good a idea because a lot of maintainers already
> handle that automatically and it is not really worth bothering the "leaf
> developers" with because that can be trivially automated.

I assume you are talking about git squashing bad line ends as it loads
the patches up.  I thought that this still triggered issues when loading
subsequent patches which relied on the context including those spaces.
Surely, this would lead to increased load on the maintainers as they
loaded those patches up?  Where the leaf maintainers use quilt would they
either not get seen or trigger failurs for him (dependant on whether he
has the option enabled), both bad outcomes.  Better to waste the time of
leaf contributers (such as myself) than any maintainers time, IMO.

> Also I still think --file needs to go, or at least be replaced with
> --file-force and warning. See the recent unpleasant incident it caused
> again, e.g.
> 
> http://thread.gmane.org/gmane.linux.kernel/656847/focus=657003
> and 
> http://thread.gmane.org/gmane.linux.kernel/656847/focus=657003

Ok, these are both the same link, so either you miss pasted one, or you
repeat to emphasise.

Reading over that thread there seems to be a few themes:

1) "don't send out 150 patches at once",
2) accepting checkpatch only changes is stupid, and
3) some maintainers do not like the style checkpatch recommends.

The first is really a general complaint against the originator, not really
a complaint about checkpatch.  Checkpatch may have prompted the changes but
that is not ultimatly its fault.  We may not like a huge pile of patches
dropped at once, but failure to recognise that is a failing in education,
not a tooling issue.  Also with the huge volumes on linux-kernel these
are hardly a major component of overall volumes?

The second is actually a matter for maintainers, either they will accept
checkpatch only changes or they won't.  Clearly Dave Miller and Andi
will not, clearly Ingo will.  Surly that is a matter for the Maintainer,
and not for the tool.

The third is about some maintainers wishing to use different style for
their parts of their tree.  That is their right, assuming those upstream
of them will accept their style.


There is a lot of polorised view on checkpatch.  But clearly there are
maintainers on both sides of the argument, those who find the tool
helps them and those who do not.  Maintainers who believe that they
should police the coding style, and find that the tool helps them with
that part of the process reducing their burden when reviewing submission.
Others who think its crap and would rather visually check style themselves,
or indeed ignore style.

On the --force-file, we tried making the warning occur in the tool itself
once before and that produced extremely vocal opposition, flame fests,
and general unhappyness, so I don't really see that flying here.  What I
do not really understand is why a simple maintainer rejection of such
patches would not work just as well, "I do not accept checkpatch style
only cleanups".  As things stand a chunk of those changes were picked up,
others implicitly rejected; lesson learned for the submitter surely.

I do feel that it may be helpful to update SubmittingPatches to mention
the problems introduced by style only churn, and (as we have a difference
of opinion) to recommend contacting the area Maintainer before embarking
on such things.  Something like the patch below perhaps?

-apw

=== 8< ===
add a note on the risks associated with wide ranging style cleanups

Add a NOTE to the SubmittingPatches guide pointing out the issues which
may occur when submitting wide ranging style cleanups, and pointing the
reader to the area maintainers.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 Documentation/SubmittingPatches |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 08a1ed1..633b9cf 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -472,6 +472,12 @@ The checker reports at three levels:
 You should be able to justify all violations that remain in your
 patch.
 
+NOTE: updating entire files purely for style violations can cause
+significant issues for other contributers and maintainers by increasing
+collisions between patches.  It is therefore recommended you contact the
+area Maintainer to ensure these patches are likely to be accepted _before_
+starting work.
+
 
 
 2) #ifdefs are ugly

