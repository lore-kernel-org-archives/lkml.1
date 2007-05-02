Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXEBMYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXEBMYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbXEBMYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:24:12 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:59487 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbXEBMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:24:11 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][ 3/5] sched: implement staircase deadline cpu scheduler
Date: Wed, 2 May 2007 22:23:51 +1000
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>
References: <200703271210.39429.kernel@kolivas.org> <20070430115014.0fff7772.akpm@linux-foundation.org>
In-Reply-To: <20070430115014.0fff7772.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705022223.51809.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 04:50, Andrew Morton wrote:
> On Tue, 27 Mar 2007 13:10:39 +1100
>
> Con Kolivas <kernel@kolivas.org> wrote:
> > Staircase Deadline cpu scheduler policy
>
> I'll be dropping this from -mm now.  I don't think we're learning anything
> more by having it in there and I generally want to get things more back
> into sync.
>
> For the record, I don't recall any problem reports arising from SD's
> presence in -mm (Except for possibly Jiri's recent "many processes end up
> in D state", but we don't have a clue what's causing that yet).

Thanks. It was a worthwhile putting it in -mm anyway because it allowed me to 
shake up a lot of bugs and stabilise it. Now SD will stick around for 
comparison. It also appears to me, having discussed with many people now, 
that hardly anyone understands how it actually works. In summary it is an 
O(1) dual array bitmap lookup based system for creating a minimal overhead 
earliest eligible virtual deadline first design. I guess I never really made 
that clear and now, ironically, with people quoting papers on that particular 
design now I probably should have. I appreciate the code does not in any way 
make it clear that that's the case because of the unique approach I used and 
doesn't really do or display any calculations in the code; it is all managed 
by handing out entitlements at priority intervals.

Anyway, good, bad or indifferent I intend to keep it around for comparison to 
drive cfs further.

-- 
-ck
