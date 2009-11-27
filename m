Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZK0PEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZK0PEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZK0PEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:04:30 -0500
Received: from smtp.nokia.com ([192.100.105.134]:16562 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZK0PE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 10:04:29 -0500
Subject: Re: Memset of length zero bugs
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <4B0E6189.6050708@gmail.com>
References: <20091111215703.GA24390@redhat.com> <4B0E6189.6050708@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 27 Nov 2009 17:04:02 +0200
Message-Id: <1259334242.7518.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Nov 2009 15:04:08.0333 (UTC) FILETIME=[DE7F73D0:01CA6F72]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 13:07 +0200, Török Edwin wrote:
... snip ...

> inlined from ‘crosstest’ at drivers/mtd/tests/mtd_pagetest.c:219:
> /home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
> warning: call to ‘__warn_memset_zero_len’ declared with attribute
> warning: memset used with constant zero length parameter; this could be
> due to transposed parameters
> 
> Now this one is interesting, the memsets are fine, however pgsize is
> always zero, it is declared as 'static int pgsize' and never assigned a
> value (hence it is always zero).
> I didn't look at what mtd_pagetest wants to test, but the name suggests
> that a pagesize of zero isn't a very useful test.

Thanks for finding this, quite shame bug. I've fixed this in my
l2-mtd-2.6.git tree:
http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/e109a419146efa5751642a11caf32b96fe187130

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

