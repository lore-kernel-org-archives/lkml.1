Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYEDQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYEDQT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYEDQTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:19:19 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:44474 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYEDQTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:19:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=QGm79I3eKxykafLW0yEQncjj88SjY+4TiV5bc+JWX7mphH3pyfnNaXYrjxqTx9vtp
	78PuDmxXHA8m+w429mKHM1QQADXLppcRolnU1uGwoLsSfdlQQoK/+ZEKZr0tr8SZnbl
	+6TwMtvkxtW50Uut2mQ20B937IcFvdITlRkEWAs=
In-Reply-To: <481DDB99.2090209@gmail.com>
Date: Sun, 04 May 2008 18:18:36 +0200 (CEST)
Cc: =?us-ascii?Q?Joe=20Perches?= <joe@perches.com>, paulus@samba.org,
       arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
To: =?us-ascii?Q?Jiri=20Slaby?= <jirislaby@gmail.com>
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20=5BPATCH=201=2F2=5D=20OF=3A=20clean=20coding=20style=20=2D=20prom=5Fparse=2Ec?=
Mime-Version: 1.0
Message-Id: <4947.7670-30939-1615027563-1209917916@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii";
	format=flowed
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm1<41193875>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

you are right. But the bugs comes from this patch http://lkml.org/lkml/2008/5/3/110.

For Paulus: Can you move these files? 

As wrote Joe. The best way will be to fix these files after moving.

Thanks,
Michal

> Hi All,
> 
> I fixed only part of coding style violation. Not all of them.

Actually, you introduced a bug. See:
http://lkml.org/lkml/2008/5/3/141

You should have used KERN_CONT, or even better sprintf and friends to be atomic

in logs.

> But you are right KERN_<level> is necessary.
> 
> For me is especially important to move these files from arch/powerpc to
drivers/of.
> 
> M
> 
>>>  /* Debug utility */
>>>  #ifdef DEBUG
>>>  static void of_dump_addr(const char *s, const u32 *addr, int na)
>>>  {
>>> -	printk("%s", s);
>>> -	while(na--)
>>> -		printk(" %08x", *(addr++));
>>> -	printk("\n");
>>> +	printk(KERN_INFO "%s", s);
>>> +	while (na--)
>>> +		printk(KERN_INFO " %08x", *(addr++));
>>> +	printk(KERN_INFO "\n");
>>>  }
>> You've prefixed KERN_INFO before every address block.
>>
>> How about:
>>
>> print_hex_dump(KERN_<level>, s, DUMP_PREFIX_NONE, 4, addr, na, false);


