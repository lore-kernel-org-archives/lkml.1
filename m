Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYGUALD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYGUALD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbYGUAJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:09:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:29227 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062AbYGUAJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LPbxHleJ+vP5Y6IoVdn32zmK56nsPlwU4U1udK7XViY7mTbIkzgJ12bTl8cloVB1A2
         pZl3pYtw1FhaTtPAvhX/BBFQp2SR1IzEYDmFYDozh+jEskz/yL8XLupI2ScePR3wd19V
         5CaA6m2RJdn6gzfPiI4txOkNxlZzLRUAwC0oo=
Message-ID: <2f11576a0807201709q45aeec3cvb99b0049421245ae@mail.gmail.com>
Date: Mon, 21 Jul 2008 09:09:26 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <87y73x4w6y.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87y73x4w6y.fsf@saeurebad.de>
X-Google-Sender-Auth: dcf7a57c49e720eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> File pages accessed only once through sequential-read mappings between
> fault and scan time are perfect candidates for reclaim.
>
> This patch makes page_referenced() ignore these singular references and
> the pages stay on the inactive list where they likely fall victim to the
> next reclaim phase.
>
> Already activated pages are still treated normally.  If they were
> accessed multiple times and therefor promoted to the active list, we
> probably want to keep them.
>
> Benchmarks show that big (relative to the system's memory)
> MADV_SEQUENTIAL mappings read sequentially cause much less kernel
> activity.  Especially less LRU moving-around because we never activate
> read-once pages in the first place just to demote them again.
>
> And leaving these perfect reclaim candidates on the inactive list makes
> it more likely for the real working set to survive the next reclaim
> scan.

looks good to me.
Actually, I made similar patch half year ago.

in my experience,
  - page_referenced_one is performance critical point.
    you should test some benchmark.
  - its patch improved mmaped-copy performance about 5%.
    (Of cource, you should test in current -mm. MM code was changed widely)

So, I'm looking for your test result :)
