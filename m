Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbZLQQVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbZLQQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762776AbZLQQVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:21:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759438AbZLQQVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:21:47 -0500
Date: Thu, 17 Dec 2009 08:21:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
In-Reply-To: <200912171708.07899.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <200912171618.32882.bzolnier@gmail.com> <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain> <200912171708.07899.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> Well, it could have been done in the other way:
> 
> -			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
> +			ret = sscanf(buf, "0x%lx - 0x%lx",
> +				     &start_addr, &end_addr);
> 
> Just an example that the limit itself is usually not a problem
> but its literal interpretation is..

What? Your version is no better.

In the above case it doesn't matter, but I've had grep's that fail due to 
people splitting the actual string etc, which just drives me wild. We 
fixed that to allow checkpatch to skip those warnings, but the fact is, 
the fundamnetal problem has always been the "80 character" part.

I don't think any kernel developers use a vt100 any more. And even if they 
do, I bet they curse the "24 lines" more than they curse the occasional 
80+ character lines.

I'd be ok with changing the warning to 132 characters, which is another 
perfectly fine historical limit. Or we can split the difference, and say 
"ok, 106 characters is too much". I don't care. But 80 characters is 
causing too many idiotic changes.

There are way worse problems in many patches than long lines. Too complex 
expressions. Too deep indentation. Pure crap code. People seem to get way 
too hung up on ".. but at least it passes checkpatch". 

		Linus
