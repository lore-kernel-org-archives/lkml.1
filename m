Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYFRXkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYFRXkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYFRXkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:40:05 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50266 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbYFRXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:40:03 -0400
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to merge
	drivers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: benh@kernel.crashing.org
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1213831894.8011.29.camel@pasglop>
References: <1213802866.3515.24.camel@localhost.localdomain>
	 <1213831894.8011.29.camel@pasglop>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 18:39:59 -0500
Message-Id: <1213832399.3515.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-19 at 09:31 +1000, Benjamin Herrenschmidt wrote:
> > The only slight wrinkle (at least for me) is that often the process of
> > cleaning up a driver is fairly intensive for a maintainer and turn
> > around is a lot faster if you're doing it in a tree you control.  (All
> > the scsi drivers we've done like this have lived in temporary branches
> > while they were being worked on).  So perhaps in addition we should be
> > encouraging maintainers to run staging branches under similar rules in
> > the staging tree, but allowing inclusion into linux-next?
> 
>  .../...
> 
> linux-next should, imho, exclusively be for things we are pretty much
> commited to merge in the next release. ie, a staging place to fixup
> things like build breakages, patch conflicts, etc...
> 
> Or else, it will just be another -mm ....

Well, as Greg said for his driver staging tree, I think we can elide
this requirement for new drivers.  The good thing about drivers is that
there's nothing we're really doing to break anything: before the driver
the hardware was just plane unusable with Linux after the driver well,
we're hoping it might be ...

> So while what you say makes sense, I think we should only put drivers in
> once we have pretty much decided that the drivers in question would be
> merged... in which case, why not straight upstream ?

The reason for staging early in linux-next is twofold

     1. We want to encourage the driver submitter that something is
        being done
     2. we want to make the driver available to a pool of testers who
        might have the hardware but might not otherwise find it so they
        can report errors that aren't picked up via the normal code
        inspection and analysis methods.

Arguably, I can do this by putting it into my upstream tree (which feeds
into linux-next) the reason for not doing so is that Linus likes us to
preserve history in there when we can.  If I need to pull the driver for
a reroll it really screws the git history (plus makes it hard for me).
If it's in its own branch, I can toy with it as much as I need to
without affecting my upstream tree.  Plus the commitment is that
anything which goes into my upstream tree should be for the next merge
window.  A driver with substantive code issues (or which shows problems
under test) might not be such a candidate until the issues are sorted
out.

James


