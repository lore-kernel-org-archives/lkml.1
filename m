Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZIUNbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZIUNbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbZIUNbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:31:40 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52336 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbZIUNbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:31:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=s55b+r7jjQTTyuknweXIi6G1dBC8toEWcpqMx6lJRyXvna7xxl8XWiNLpcdw1fODsE
         z2LWmb5JRrtJiUefX6JY6R0+3YkCGlNbSR6ll9G4guH8bFc6FTRqgWgIzQkB7rS82L2v
         hAW9DGSII4xPUJhvNuieEQ5xS2ljnCzDqyk+o=
MIME-Version: 1.0
In-Reply-To: <20090921130440.GN12726@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
	 <1253302451-27740-2-git-send-email-mel@csn.ul.ie>
	 <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com>
	 <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi>
	 <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com>
	 <20090921084248.GC12726@csn.ul.ie> <20090921130440.GN12726@csn.ul.ie>
Date: Mon, 21 Sep 2009 16:31:42 +0300
X-Google-Sender-Auth: d6a4fa9e2605b1f6
Message-ID: <84144f020909210631h23bf3292q1d87c063c7b5c126@mail.gmail.com>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Sachin Sant <sachinp@in.ibm.com>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 4:04 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> The "per-cpu" area in this case is actually a per-node area. This implied that
>> it was either racing (but the locking looked sound), a buffer overflow (but
>> I couldn't find one) or the per-cpu areas were being written to by something
>> else unrelated.
>
> This latter guess was close to the mark but not for the reasons I was
> guessing. There isn't magic per-cpu-area-freeing going on. Once I examined
> the implementation of per-cpu data, it was clear that the per-cpu areas for
> the node IDs were never being allocated in the first place on PowerPC. It's
> probable that this never worked but that it took a long time before SLQB
> was run on a memoryless configuration.
>
> This patch would replace patch 1 of the first hatchet job I did. It's possible
> a similar patch is needed for S390. I haven't looked at the implementation
> there and I don't have a means of testing it.

Other architectures could be affected as well which makes me think
"hatchet job number one" is the way forward. Nick?

                        Pekka
