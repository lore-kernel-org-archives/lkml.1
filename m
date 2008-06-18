Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYFRMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYFRMvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYFRMv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:51:29 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:24721 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751176AbYFRMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:51:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oSzRR3/XvMiavrVV5127Awrf2atPAazvp2zQa15xvIQEMiPVYHe31z+ODUnOi+SyZkYg4NDofJ1HbhxtXgM1x+rlIU0la29kPEJ+CBmdz1ow56ikdwhcnNnCzuFkB55XTURiwx5MQK9PA7PTAQdY8HEUp07bl7ugivP1BbTUQ+w=  ;
X-YMail-OSG: wZhnRpUVM1mb0wZzyNeysFQrwDrWagHdshqn2ELg8O7La.rxz3frS5AWnMFkQ4M9NEKk58vcHTYoyYd70TwYSgABLqOlJSva0pSGXMkWQw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] MM: virtual address debug
Date: Wed, 18 Jun 2008 22:51:02 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>
References: <1213271800-1556-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1213271800-1556-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806182251.02486.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 21:56, Jiri Slaby wrote:
> Add some (configurable) expensive sanity checking to catch wrong address
> translations on x86.
>
> - create linux/mmdebug.h file to be able include this file in
>   asm headers to not get unsolvable loops in header files
> - __phys_addr on x86_32 became a function in ioremap.c since
>   PAGE_OFFSET, is_vmalloc_addr and VMALLOC_* non-constasts are undefined
>   if declared in page_32.h

Uh, I have to disagree with this. __phys_addr is used in some really
performance critical parts of the kernel, and the function calls are
free mindset is just wrong. Even for modern x86 CPUs, the function
call return might take 10 cycles or more when you include all costs.

And for something like this

#define __phys_addr(x)         ((x) - PAGE_OFFSET)

the code to call the function is probably bigger than inline generated
code anyway.
