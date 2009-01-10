Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZAJUXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZAJUXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZAJUXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:23:31 -0500
Received: from lazybastard.de ([212.112.238.170]:43895 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZAJUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:23:31 -0500
Date: Sat, 10 Jan 2009 21:23:16 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090110202315.GE20611@logfs.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fxjrgd9s.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 January 2009 20:41:03 +0100, Andi Kleen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > Also, to elaborate on that answer, I'm going to use this as a sort of
> > hash table for wireless, where it ensures better scalability than a pure
> > hashtable from quiet environments (say wireless off on an airplane) to
> > your wireless test lab (100+ access points)
> 
> Is there any particular reason you can't use the standard rbtrees
> for that?

Can't think of any.  You can use linked lists as well.  Whether you want
to is a different matter.

Key difference is the number of cachelines you need to find a particular
entry.  rbtrees have a fanout of sqrt(3), so for a million elements (to
pick a random example) you need about 25 cachelines with rbtrees and
about 5-16 with btrees.  Closer to 5 if keys and pointers are small and
cachelines are large, closer to 16 if keys and pointers are large and
cachelines are small.

Jörn

-- 
The key to performance is elegance, not battalions of special cases.
-- Jon Bentley and Doug McIlroy
