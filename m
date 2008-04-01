Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbYDAUAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbYDAUAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbYDAUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:00:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43982 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbYDAUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:00:04 -0400
Date: Tue, 1 Apr 2008 22:00:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Pull] Some documentation patches
In-Reply-To: <47F0F5CA.8050404@gmail.com>
Message-ID: <alpine.LNX.1.10.0804012152060.6604@fbirervta.pbzchgretzou.qr>
References: <13387.1206728412@vena.lwn.net> <alpine.LNX.1.10.0803282005440.27567@fbirervta.pbzchgretzou.qr> <47F0F5CA.8050404@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-03-31 16:31, Dmitri Vorobiev wrote:
>> @@ -107,8 +107,8 @@ complete. Here's the example version:
>>
>>      static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
>>      {
>> -            loff_t *spos = (loff_t *) v;
>> -            *pos = ++(*spos);
>> +            loff_t *spos = v;
>> +            *pos = ++*spos;
>
> Excuse me, what's the point in this change and the next one? IMO, removing
> the explicit type cast makes the code less obvious.

Why should it be less obvious? Exactly left to the (loff_t *) you
already have loff_t *, so you know where you are going from v,
whose type is also obviously visible right in the line above.
Casts can hide errors. The cast is redundant, it does not
cover up a compiler warning. Even so, casts can hide programming
errors, as in http://jengelh.hopto.org/2007/0616-nocast.php .

> Relying upon operator priorities instead of explicit
> operator grouping using parentheses can confuse people, too.

In case of *a++ I would agree -- you would need to know whether * or
++ has the higher precedence (hint: ++ has). But in ++*a it does not
matter how much precedence either has, it always means the same.
Just like an arithmetic expression "x*-5".
