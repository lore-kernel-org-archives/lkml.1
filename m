Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZEJKGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZEJKGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 06:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZEJKGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 06:06:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:32031 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZEJKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 06:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YBmW7fMWEkJCP0E4y3cr1vc740Tq2DtfgO0K04hHH4RfN91WC8hFTXi7n3CNjKQSiJ
         6AuW0ESOHbrLVK+ei2olGAalQc7WKreAa5xvY7ueJMTD7v8IS9nfFD6X2GGZ2C1/EVMY
         6DftFBeBhrR+tY89eAzqcTMM2x/4UfzH4WmO8=
MIME-Version: 1.0
In-Reply-To: <20090510093541.GB7651@localhost>
References: <20090503031539.GC5702@localhost>
	 <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org>
	 <20090507134410.0618b308.akpm@linux-foundation.org>
	 <20090508081608.GA25117@localhost>
	 <20090508125859.210a2a25.akpm@linux-foundation.org>
	 <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <1241946446.6317.42.camel@laptop> <20090510093541.GB7651@localhost>
Date: Sun, 10 May 2009 19:06:34 +0900
X-Google-Sender-Auth: ad797f41796cd9be
Message-ID: <2f11576a0905100306q3c087da8td834026a5161fe68@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I don't think this is desirable, like Andrew already said, there's tons
>> of ways to defeat any of this and we've so far always priorized mappings
>> over !mappings. Limiting this to only PROT_EXEC mappings is already less
>> than it used to be.
>
> Yeah. One thing I realized in readahead is that *anything* can happen.
> When it comes to caching, app/user behaviors are *far more* unpredictable.
> We can make the heuristics as large as 1000LOC (and leave users and
> ourselves lost in the mist) or as simple as 100LOC (and make it happy
> to hacking or even abuse).

umm. I think it isn't good example.
Please see recent_scan/rotate stastics. it use only less 100LOC.

Plus, I don't think stastics is wrong.
if the page can claim "I'm high priority", it's risky. bad userland
program might exploit this rule.
but if the page claim "I think PROT_EXEC is important, maybe", it
isn't risky. if user-program want to exploit the rule, kernel ignore
the claim.
