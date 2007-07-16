Return-Path: <linux-kernel-owner+w=401wt.eu-S1764885AbXGPMX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764885AbXGPMX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbXGPMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:23:21 -0400
Received: from fep02.mfe.bur.connect.com.au ([203.63.86.22]:58208 "EHLO
	fep02.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605AbXGPMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:23:20 -0400
Message-ID: <469B626D.4060700@murdoch.edu.au>
Date: Mon, 16 Jul 2007 20:19:57 +0800
From: "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Including STRTOK_R in a LSM
References: <469B31E8.6050906@murdoch.edu.au> <Pine.LNX.4.64.0707161214140.686@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707161214140.686@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What I need is to ignore double delimiters such as (::). This can be 
done trivially with a string comparison to check for "\0". What I want 
to know is if it is ok to include the strtok_r code in my security 
module, or if strtok was removed for a very good reason. I am porting a 
lot of existing code which already uses strtok_r to a kernel security 
module.

Thanks,

Cliffe.

Jan Engelhardt wrote:
> On Jul 16 2007 16:52, Z. Cliffe Schreuders wrote:
>   
>> I am aware strtok was removed from the kernel in 2002. However strtok_r is more
>> desirable than strsep as I do not want to know about 'blank fields' (2
>> consecutive delimiters). Is it acceptable to simply include the strtok_r code
>> in my security module? or should I create a wrapper for strsep to ignore
>> blanks?
>>     
> 12:16 ichi:/dev/shm > cat test.c 
> #include <stdio.h>
> #include <string.h>
> int main(void)
> {
>         char x[] = "foo::bar";
>         char *w = x;
>         char *p;
>         while ((p = strsep(&w, ":")) != NULL)
>                 printf("\"%s\"\n", p);
> }
> 12:16 ichi:/dev/shm > ./a.out 
> "foo"
> ""
> "bar"
>
>
> q.e.d.
>
>
> 	Jan
>   

