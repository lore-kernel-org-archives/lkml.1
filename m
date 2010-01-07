Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861Ab0AGROv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0AGROv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191Ab0AGROu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:14:50 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49978 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0AGROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:14:50 -0500
X-Greylist: delayed 1687 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 12:14:50 EST
Message-ID: <4B460F98.9000208@s5r6.in-berlin.de>
Date: Thu, 07 Jan 2010 17:45:12 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] Add BUILD_BUG_ON_NOT_POWER_OF_2()
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com> <20100106123306.ac85e557.akpm@linux-foundation.org> <aday6kbt14a.fsf@roland-alpha.cisco.com> <20100106134232.0025e818.akpm@linux-foundation.org> <adaeim2supb.fsf_-_@roland-alpha.cisco.com> <alpine.LFD.2.00.1001070332060.16874@localhost>
In-Reply-To: <alpine.LFD.2.00.1001070332060.16874@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   my normal pedantry coming to the surface, but can we at least assume
> that people will use this test to *legitimately* test whether or not
> something is a power of two, and not that there is a single bit set
> (in the case of mask bits where all settings must be mutually
> exclusive)?
> 
>   there's a lot of this sort of thing throughout the kernel:
> 
>     (n) != 0 && (((n) & ((n) - 1))
> 
> but it's sometimes unclear whether someone is testing for a) power of
> two, or b) single bit set.  if you're going to introduce that kind of
> BUILD BUG (which is a good idea), let's try to not immediately abuse
> it semantically. :-)

It's merely about math, not about semantics.  Plus, its application is
restricted to build-time checks (of defined constants) anyway.

Hence I would argue that "check at build time whether a defined
bitmask's Hamming weight is 1; abort build if it isn't" can be
legitimately and sufficiently readably implemented by means of the new
BUILD_BUG_ON_NOT_POWER_OF_2().
-- 
Stefan Richter
-=====-==-=- ---= --===
http://arcgraph.de/sr/
