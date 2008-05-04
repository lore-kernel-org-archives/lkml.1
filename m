Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYEDPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYEDPwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYEDPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:52:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:43288 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYEDPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j1jAaK05r0cr2zashuEGyKj6nVuV0AN6QS962BDIuqwZwltBu7BjKk9KKYFd3p0FmUiGoZlzJnHOxh3sSXNBhm1H0qGIU9mT20TZWI2ualxS8WAYcSN9Nga1bHMl5NPzJCvhgEtDn2LufKhnK++8Sgk36xq2Fq9VtxZHLKc64l0=
Message-ID: <481DDB99.2090209@gmail.com>
Date: Sun, 04 May 2008 17:51:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: monstr@seznam.cz
CC: Joe Perches <joe@perches.com>, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] OF: clean coding style - prom_parse.c
References: <monstr@seznam.cz>	 <1209827626-8562-1-git-send-email-monstr@seznam.cz>	 <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu> <1209835583.16966.10.camel@localhost> <481D711E.6000003@seznam.cz>
In-Reply-To: <481D711E.6000003@seznam.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2008 10:17 AM, Michal Simek wrote:
> Hi All,
> 
> I fixed only part of coding style violation. Not all of them.

Actually, you introduced a bug. See:
http://lkml.org/lkml/2008/5/3/141

You should have used KERN_CONT, or even better sprintf and friends to be atomic 
in logs.

> But you are right KERN_<level> is necessary.
> 
> For me is especially important to move these files from arch/powerpc to drivers/of.
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
