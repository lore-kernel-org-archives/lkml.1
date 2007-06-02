Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbXFBRrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbXFBRrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbXFBRrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:47:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761852AbXFBRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:47:14 -0400
Date: Sat, 2 Jun 2007 10:47:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-Id: <20070602104700.53b6b811.akpm@linux-foundation.org>
In-Reply-To: <20070602141144.GC5500@stusta.de>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<20070602141144.GC5500@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 16:11:45 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> On Thu, May 31, 2007 at 07:09:10PM -0700, akpm@linux-foundation.org wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Explain what we use Acked-by: for, and how it differs from Signed-off-by:
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  Documentation/SubmittingPatches |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff -puN Documentation/SubmittingPatches~document-acked-by Documentation/SubmittingPatches
> > --- a/Documentation/SubmittingPatches~document-acked-by
> > +++ a/Documentation/SubmittingPatches
> > @@ -328,7 +328,20 @@ now, but you can do this to mark interna
> >  point out some special detail about the sign-off. 
> >  
> >  
> > -12) The canonical patch format
> > +12) When to use Acked-by:
> > +
> > +The Signed-off-by: tag implies that the signer was involved in the development
> > +of the patch, or that he/she was in the patch's delivery path.
> 
> The last part should be dropped: If "he/she was in the patch's delivery 
> path", a Signed-off-by: tag is required.

I don't get you.  Isn't that already what the text says?

> > +If a person was not directly involved in the preparation or handling of a
> > +patch but wishes to signify and record their approval of it then they can
> > +arrange to have an Acked-by: line added to the patch's changelog.
> > +
> > +Acked-by: is often used by the maintainer of the affected code when that
> > +maintainer neither wrote, merged nor forwarded the patch themselves.
> 
> "merged" seems to be superfluous if you also mention "forwarded".

OK

> > +13) The canonical patch format
> >  
> >  The canonical patch subject line is:
> 
> Please mention explicitely whether Acked-by: this now considered a 
> formal tag like Signed-off-by:

OK.

> IOW, if a maintainer says "fine with me", can I translate this to an 
> Acked-by: line, or do I now have to ask for an explicit Acked-by: line?

I do that often.  It's useful information.  If person X sends an fbdev
patch and Tony says "whoa, neat" and I send the patch to Linus then Linus could
well think "wtf, Andrew doesn't know anything about fbdev".  So I do s/whoa
neat/Acked-by:/ to tell the world that someone who knows something has
looked at the change.

> Oh, and that's not a theoretical question, this is a result of a recent 
> flamewar^Wdiscussion on this list...

yeah, well, what isn't ;)

The person whose Acked-by: I added will get a copy of the added-to-mm email
so if they didn't want that acked-by added then they get a chance to remove
it again.


From: Andrew Morton <akpm@linux-foundation.org>

Explain what we use Acked-by: for, and how it differs from Signed-off-by:

Acked-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~document-acked-by Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~document-acked-by
+++ a/Documentation/SubmittingPatches
@@ -340,8 +340,32 @@ now, but you can do this to mark interna
 point out some special detail about the sign-off. 
 
 
+13) When to use Acked-by:
 
-13) The canonical patch format
+The Signed-off-by: tag implies that the signer was involved in the development
+of the patch, or that he/she was in the patch's delivery path.
+
+If a person was not directly involved in the preparation or handling of a
+patch but wishes to signify and record their approval of it then they can
+arrange to have an Acked-by: line added to the patch's changelog.
+
+Acked-by: is often used by the maintainer of the affected code when that
+maintainer neither contributed to nor forwarded the patch themselves.
+
+Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
+has at least reviewed the patch and has indicated acceptance.  Hence patch
+mergers will sometimes manually covert an acker's "yep, looks good to me" into
+an Acked-by:.
+
+Acked-by: does not necessarily indicate acknowledgement of the entire patch. 
+For example, if a patch affects multiple subsystems and has an Acked-by: from
+one subsystem maintainer then this usually indicates acknowledgement of just
+the part which affects that maintainer's code.  Judgement should be used here.
+When in doubt people should refer to the original discussion in the mailing
+list archives.
+
+
+14) The canonical patch format
 
 The canonical patch subject line is:
 
_

