Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbZJOSYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbZJOSYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZJOSYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:24:11 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:29201 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbZJOSYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=eLeuKuEzvyFrJQUI2yy39DD3WpgwjgKNsM+TEmKwL24/ew4xNm/G/DI1BlT2XoGfDn
         4XknpNKZl43nA158ANMgFRwKyrtvIEmxNTI0Kvb1DiisfoQI/EdZJfmPeEhGgA2Rp4y3
         61JsUDjZShXhhd3FB/41iOa4vvpIpdrNVCxn4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: removing existing working drivers via staging
Date: Thu, 15 Oct 2009 20:20:12 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: david@lang.hm, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de>
In-Reply-To: <20091015174932.GA3595@suse.de>
MIME-Version: 1.0
Message-Id: <200910152020.13080.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009 19:49:32 Greg KH wrote:
> On Thu, Oct 15, 2009 at 07:42:40PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 15 October 2009 18:47:26 Greg KH wrote:
> > > On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
> > > > however, what I think I saw proposed was to move drivers that need to be 
> > > > 'cleaned up', to staging and then dropping them if they don't get cleaned.
> > > 
> > > What is "proposed" is the following:
> > > 
> > > 	- For drivers currently in the kernel tree, that the subsystem
> > > 	  maintainer, for whatever reason, feels is obsolete / broken /
> > > 	  needs major cleaning / wants to get rid of, can be submitted
> > > 	  to the staging maintainer to be moved to the drivers/staging/
> > > 	  directory.
> > 
> > This is insanity and opens a door for various forms of abuse.
> 
> What do you mean by this?  What kind of "abuse"?

Typical situation:

You have driver for _really_ difficult hardware used by minority of total
users of a given subsystem.  Said driver has no major problems except being
f*cking complicated (because of hardware) so it stays in the way of future
changes.

With the current system people making bigger changes have to comprehend
that difficult stuff [*].  This is a good thing in the long-term since it
results in the better overall system understanding, better knowledge of
"DO's and DON'T's" and better users' experience.

Now with the proposed scheme it is sufficient to throw said driver into
staging for few weeks and make future changes.  Before users even notice
and complain they are screwed already since bringing the driver back is
no longer possible without big effort (+ subsystem is still evolving)..

This will result in a "new kernel new hardware" world that some distro
people have been silently trying to accomplish and in this brave new world
few key people have way too much advantage over everyone else.

[*] Booing current maintainer and forking also sometimes works.
(Though old drivers are still in place in such situation.)

