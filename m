Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZAVKBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZAVKBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZAVKB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:01:28 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:41732 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbZAVKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:01:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fzepBKyHxpqAmURD5OD0+yg4UulS3Es/D45KwaPy4VdMSEVt6ThUqRsmMy3m/NW51M
         peklbiLMGtZsx9jG0YBJjotXiuDq+5fov6VEiOTPszCnVq/Eb6AwmTmTBAkvbhbjEdpt
         WJtOADG/t5LnTaNBh7kH1pW2QIEesOcCcra3Y=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901211705570.7020@blonde.anvils>
References: <20090121143008.GV24891@wotan.suse.de>
	 <Pine.LNX.4.64.0901211705570.7020@blonde.anvils>
Date: Thu, 22 Jan 2009 12:01:24 +0200
X-Google-Sender-Auth: fec1038159e3581f
Message-ID: <84144f020901220201g6bdc2d5maf3395fc8b21fe67@mail.gmail.com>
Subject: Re: [patch] SLQB slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Wed, Jan 21, 2009 at 8:10 PM, Hugh Dickins <hugh@veritas.com> wrote:
> I was initially _very_ impressed by how well it did on my venerable
> tmpfs loop swapping loads, where I'd expected next to no effect; but
> that turned out to be because on three machines I'd been using SLUB,
> without remembering how default slub_max_order got raised from 1 to 3
> in 2.6.26 (hmm, and Documentation/vm/slub.txt not updated).
>
> That's been making SLUB behave pretty badly (e.g. elapsed time 30%
> more than SLAB) with swapping loads on most of my machines.  Though
> oddly one seems immune, and another takes four times as long: guess
> it depends on how close to thrashing, but probably more to investigate
> there.  I think my original SLUB versus SLAB comparisons were done on
> the immune one: as I remember, SLUB and SLAB were equivalent on those
> loads when SLUB came in, but even with boot option slub_max_order=1,
> SLUB is still slower than SLAB on such tests (e.g. 2% slower).
> FWIW - swapping loads are not what anybody should tune for.

What kind of machine are you seeing this on? It sounds like it could
be a side-effect from commit 9b2cd506e5f2117f94c28a0040bf5da058105316
("slub: Calculate min_objects based on number of processors").

                                Pekka
