Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0BAHUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:20:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46990
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673Ab0BAHUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:20:37 -0500
Date: Sun, 31 Jan 2010 23:20:50 -0800 (PST)
Message-Id: <20100131.232050.266652459.davem@davemloft.net>
To: xtfeng@gmail.com
Cc: rjw@sisk.pl, htd@fancy-poultry.org, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
From: David Miller <davem@davemloft.net>
In-Reply-To: <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	<d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
	<7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>
Date: Mon, 1 Feb 2010 11:30:02 +0800

> On Mon, Feb 1, 2010 at 8:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.32.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15196
>> Subject         : kmem_cache_create: duplicate cache ccid2_h
>> Submitter       : Heinz Diehl <htd@fancy-poultry.org>
>> Date            : 2010-01-30 18:33 (2 days old)
>> References      : http://marc.info/?l=linux-kernel&m=126487640324942&w=4
> 
> Cced Neil,
> 
> I think this one is introduced by commit
> de4ef86cfce60d2250111f34f8a084e769f23b16,
> passing char *slab_name_fmt as function parameter, but vsnprintf is
> using sizeof(slab_name_fmt),
> which is 8 (or 4 in 32bit kernel) instead of 32 as old version.
> 
> Does following patch resolve this bug, Heinz?

There seems to be even more to this than that.  Neils
patch seems to need completely reverting.

See the patch set posted by Gerrit Renker:

http://marc.info/?l=linux-netdev&m=126500585823775&w=2
http://marc.info/?l=linux-netdev&m=126500591923880&w=2
