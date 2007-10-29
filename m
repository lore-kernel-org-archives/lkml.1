Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXJ2KPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXJ2KPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbXJ2KPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:15:09 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1750 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbXJ2KPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:15:07 -0400
X-Greylist: delayed 729 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 06:15:06 EDT
Message-ID: <15466.80.126.27.205.1193652063.squirrel@webmail.xs4all.nl>
Date: Mon, 29 Oct 2007 11:01:03 +0100 (CET)
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to 
     static interface)
From: "Rob Meijer" <capibara@xs4all.nl>
To: casey@schaufler-ca.com
Cc: "Chris Wright" <chrisw@sous-sol.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Reply-To: rmeijer@xs4all.nl
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, October 25, 2007 02:42, Casey Schaufler wrote:
>
> I agree that security code does need to provide security. What we
> need to get away from is the automatic attacks that are based on 20th
> century computer system assumptions. Things like "name based access
> control is rediculous", and "a module can't be any good if it doesn't
> deal with all objects", or "the granularity isn't fine enough". Look
> at TOMOYO. It's chuck full of good ideas. Why spend so much energy
> badgering them about not dealing with sockets? How about helping the
> AppArmor crew come up with acceptable implementations rather than
> whinging about the evils of hard links? And maybe, just maybe, we can
> get away from the inevitable claim that you could do that with a few
> minutes work in SELinux policy, but only if you're a security
> professional of course.

What may be even more relevant are those concepts that couldn't be done
in SELinux, and how proposals that come from the theory of alternative
access controll models (like object capability modeling) are dismissed
by the aparently largely MLS/MAC oriented people on the list.

In a wider contect than just this list, it apears to me that MLS and
Obj Caps advocates simply dismiss the alternative models as broken or as
irrelevant at best. In my view this attitude is very much pressent on
the MLS list.

It might in the light of this attitude even be a viable option to just
simply spin off 3 (or more) sets of LSM module sets, and maybe even put
some ifdefs in the base code depending on the chosen access controll model,
if for some reason the 'model' warants some major patch.

To me it would look like a good concept if LSM/Linux would try to support
all exisiting formal models of access controll, but without the need to
support all implementation alternatives for these models. That is, if a
module 'requires' a patch but the underlaying formal model does not, than
it would seem reasonable that the module be fixed. If however the 'model'
seems to require the patch, it may be perfectly reasonable for this patch
to be implemented, if need be with an ifdef for the used model.

Thus IMHO it may be a good idea to instead of a maintainer for LSM
modules as proposed, alternatively a maintainer for each formal model
may be more appropriate. This also would require module builders to first
think about what formal model they are actualy using, thus resulting in
cleaner module design.



Rob

