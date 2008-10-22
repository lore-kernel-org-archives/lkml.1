Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYJVWLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYJVWLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJVWKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:10:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34271 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbYJVWKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:10:50 -0400
To: cl@linux-foundation.org
CC: miklos@szeredi.hu, penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <Pine.LNX.4.64.0810221416130.26639@quilx.com> (message from
	Christoph Lameter on Wed, 22 Oct 2008 14:28:57 -0700 (PDT))
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> 
 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>  <48FE6306.6020806@linux-foundation.org>
  <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810220822500.30851@quilx.com>
  <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221252570.3562@quilx.com>
  <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221315080.26671@quilx.com>
  <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu> <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0810221416130.26639@quilx.com>
Message-Id: <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Oct 2008 00:10:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Christoph Lameter wrote:
> On Wed, 22 Oct 2008, Miklos Szeredi wrote:
> 
> >> Actually, when debugging is enabled, it's customary to poison the
> >> object, for example (see free_debug_processing() in mm/slub.c). So we
> >> really can't "easily ensure" that in the allocator unless we by-pass
> >> all the current debugging code.
> 
> Plus the allocator may be reusing parts of the freed object for a freelist 
> etc even if the object is not poisoned.

Actually, no: looking at the slub code it already makes sure that
objects are neither poisoned, nor touched in any way _if_ there is a
constructor for the object.  And for good reason too, otherwise a
reused object would contain rubbish after a second allocation.

Come on guys, you should be the experts in this thing!

So again, just checking d_lru should do work fine.  There's absolutely
no need to mess with extra references in a separate phase, which leads
to lots of complications.

Miklos
