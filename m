Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbXF0CtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbXF0CtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbXF0CtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:49:07 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54816 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbXF0CtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:49:06 -0400
X-Sasl-enc: /4zGgRHNcaswn1gtW0C+JZ2uWdv7X9XfEcNcReuQcGLx 1182912543
Date: Tue, 26 Jun 2007 23:48:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matt Mackall <mpm@selenic.com>
Cc: Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Message-ID: <20070627024856.GB5491@khazad-dum.debian.net>
References: <200706262021.51410.mb@bu3sch.de> <20070626224517.GG11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626224517.GG11115@waste.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Matt Mackall wrote:
> On Tue, Jun 26, 2007 at 08:21:51PM +0200, Michael Buesch wrote:
> > Don't use the word "quality", as people seem to think of
> > the entropy quality when hearing that word.
> 
> Why do I so often feel compelled to respond with "did you read what I
> wrote?" on this list?
> 
> I object to your MEANINGLESS CATEGORIES.
> 
> > This uses the word "type", which is probably better for
> > understanding what the value really means.
> 
> Please explain:
> 
> a) how is bad different from pseudo?
> b) how is onboard different than dedicated?

Actually, I think I understand the reason behind (b).  If someone adds a
dedicated crypto/RNG engine to the system, he likely wants to use that and
not anything else that might also be around.

(a) is just broken, unless one is to take it as "never use it".  And I am
really not sure about (b).  It *is* better than just using whatever crap we
found first (or last), but it is the wrong solution for a problem that we
really should not have in the first place if someone had thought a bit
before adding a misc device for something that has no reason to be unique in
a system.

Instead of papering over the problem with borked solutions, maybe we should
just export ALL HRNGs to userspace.  While at it, please add whatever is
needed so that userspace can talk to the kernel driver to get vital
information about the HRNG device the driver might have (the current
interface is a bad simplistic hack).

Let userspace get the data from whichever HRNG it wants, process it in any
way it wants and pipe it back through /dev/random IOCTLs.  And let it do it
for as many HRNGs it wants at the same time.

And if you must have /dev/hw_random point somewhere, let udev scripts or
something else like that take care of it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
