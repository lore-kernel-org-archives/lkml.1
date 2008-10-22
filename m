Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYJVVFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYJVVFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYJVVEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:04:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60961 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbYJVVEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:04:49 -0400
To: penberg@cs.helsinki.fi
CC: miklos@szeredi.hu, cl@linux-foundation.org, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
	(penberg@cs.helsinki.fi)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop>
	 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>
	 <48FE6306.6020806@linux-foundation.org>
	 <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810220822500.30851@quilx.com>
	 <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221252570.3562@quilx.com>
	 <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221315080.26671@quilx.com>
	 <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu> <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
Message-Id: <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Oct 2008 23:04:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Pekka Enberg wrote:
> On Wed, Oct 22, 2008 at 11:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > Because you don't _need_ a reliable reference to access the contents
> > of the dentry.  The dentry is still there after being freed, as long
> > as the underlying slab is there and isn't being reused for some other
> > purpose.  But you can easily ensure that from the slab code.
> >
> > Hmm?
> 
> Actually, when debugging is enabled, it's customary to poison the
> object, for example (see free_debug_processing() in mm/slub.c). So we
> really can't "easily ensure" that in the allocator unless we by-pass
> all the current debugging code.

Thank you, that does actually answer my question.  I would still think
it's a good sacrifice to no let the dentries be poisoned for the sake
of a simpler dentry defragmenter.

Miklos
