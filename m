Return-Path: <linux-kernel-owner+w=401wt.eu-S2992656AbXCXBS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992656AbXCXBS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 21:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992659AbXCXBS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 21:18:27 -0400
Received: from smtpout.mac.com ([17.250.248.185]:59436 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992656AbXCXBS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 21:18:26 -0400
In-Reply-To: <1757F955-52E4-415C-B8F4-4C70477B59D6@mac.com>
References: <20061214223718.GA3816@elf.ucw.cz> <20061216094421.416a271e.randy.dunlap@oracle.com> <20061216095702.3e6f1d1f.akpm@osdl.org> <458434B0.4090506@oracle.com> <1166297434.26330.34.camel@localhost.localdomain> <20061219063413.GI24090@1wt.eu> <1166511171.26330.120.camel@localhost.localdomain> <20070106103331.48150aed.randy.dunlap@oracle.com> <459FF60D.7080901@zytor.com> <1168112266.2821.2.camel@entropy> <20070106121301.d07de0c9.akpm@osdl.org> <45A0041F.4060903@zytor.com> <20070319122740.286f602e.randy.dunlap@oracle.com> <20070319133613.9f4881db.akpm@linux-foundation.org> <45FEF5BC.90809@oracle.com> <45FF6189.9080508@zytor.com> <20070321160132.983812ac.randy.dunlap@oracle.com> <20070321161140.457a3cd7.akpm@linux-foundation.org> <CDF579E6-342C-4B99-916A-3CE118ABD02F@mac.com> <46043A66.7030102@oracle.com> <46043F96.8030800@zytor.com> <1757F955-52E4-415C-B8F4-4C70477B59D6@mac.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E70919C8-1D2B-4F47-8086-C50E6EEC1D91@mac.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
Date: Fri, 23 Mar 2007 21:17:35 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 23, 2007, at 20:45:21, Kyle Moffett wrote:
> On Mar 23, 2007, at 16:59:02, H. Peter Anvin wrote:
>> Randy Dunlap wrote:
>>> That makes a lot of sense to me.  It gives us finer-grained  
>>> control without having to support fixed-point data.  I've been  
>>> working on the fixed-point data patch, but I'm going to give this  
>>> method some time also, to see how it looks in code (instead of  
>>> just thinking about it).
>>
>> Well, to be specific, it actually is the same thing with different  
>> syntax (38.55 or 3855/100).
>
> /* On input: reduce num/den but retain old values for display  
> purposes */
> gcd = euclid(&inputnum, &inputden);
> num = inputnum/gcd;
> den = inputden/gcd;

Whoops, if I divide inputnum and inputden by gcd I don't need to pass  
by reference.

The trivial implementation of euclid (modulo the bogus address-of  
operations above) is of course something like this:

unsigned long euclid(unsigned long a, unsigned long b)
{
	unsigned long q, r;

	if (!a || !b)
		return 1;

	do {
		q = a / b;
		r = a % b;
		a = b;
		b = r;
	} while (r);

	return a;
}

