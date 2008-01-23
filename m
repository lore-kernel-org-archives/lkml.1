Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbYAWJGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbYAWJGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYAWJGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:06:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34686 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYAWJGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:06:17 -0500
Date: Wed, 23 Jan 2008 10:06:15 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bryan Wu <cooloney.lkml@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <bryan.wu@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] procfs: constify function pointer tables
In-Reply-To: <386072610801222018l79cca93dlda987af4c2036931@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801231005090.12676@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
  <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
 <386072610801222018l79cca93dlda987af4c2036931@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23 2008 12:18, Bryan Wu wrote:
>> [PATCH] procfs: constify function pointer tables
>> ---
>>  arch/alpha/kernel/setup.c     |    2 +-
>>  arch/blackfin/kernel/setup.c  |    2 +-
>>  [...]
>> diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
>> index bd5e68c..823f18e 100644
>> --- a/arch/alpha/kernel/setup.c
>> +++ b/arch/alpha/kernel/setup.c
>> @@ -1472,7 +1472,7 @@ c_stop(struct seq_file *f, void *v)
>>  {
>>  }
>>
>> -struct seq_operations cpuinfo_op = {
>> +const struct seq_operations cpuinfo_op = {
>>         .start  = c_start,
>>         .next   = c_next,
>>         .stop   = c_stop,
[...]
>Thanks, I understand the seq_xxx() API needs "const struct seq_operations *".
>So for Blackfin part, I agree with Mike.
>
>but there are still some other files need add "const":
>---
>/opt/git-tree/blackfin-2.6$ grep -r seq_operations arch/*
>arch/alpha/kernel/setup.c:struct seq_operations cpuinfo_op = {

The patch already touches that :-)
