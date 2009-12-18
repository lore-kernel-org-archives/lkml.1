Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZLROhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZLROhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZLROhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:37:07 -0500
Received: from khc.piap.pl ([195.187.100.11]:44297 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZLROhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:37:05 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Joe Perches <joe@perches.com>
Cc: Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105 chars
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
Date: Fri, 18 Dec 2009 15:37:00 +0100
In-Reply-To: <1261113144.13734.317.camel@Joe-Laptop.home> (Joe Perches's
	message of "Thu, 17 Dec 2009 21:12:24 -0800")
Message-ID: <m3iqc41h83.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> I think this is a good test to add to checkpatch.
>
> Add 105 character long line WARN test

Not sure if that's long enough (maybe it is).
132 looks like the next "natural" number.
The problematic case like printk(KERN_DEBUG "%s:%s:%s", var ? "yes" :
"no" and so on. If we split the code like that then better use 132 than
105 - even with 132 chars we may need to split, remember it's the printk
output which has to fit in 80 chars, or maybe usually has.

The main problem is checkpatch can't estimate "complexity". Fortunately
the reviewers can.

> Add 80 character long line STRICT test

Not sure what do you mean.

> Add 6+ leading indent tabs test, consider restructuring

This makes perfect sense, at least until shown otherwise (though being
a warning instead of an error means it's ok to trigger in perfectly
valid code).
-- 
Krzysztof Halasa
