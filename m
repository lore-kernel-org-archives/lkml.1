Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZGABfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZGABfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbZGABfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:35:16 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:50326 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761692AbZGABfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Fz0TXYwb7Ff92rsqKAK6mv3S/sIq462cNursY0E5kg5RfjDtQ0jZBcSlB1xqw9+YMn
         Xjng4dhBR3Tv3//bmYbH50ExubDzsiM0fmY1fCsXSbA7j66a6pcQpfjXTW3K6ZFBBsc4
         nleAsWvEQ4QVyT5SDqwl4pyB5Yvrn6oAD0bQM=
Message-ID: <4A4ABD8F.40907@gmail.com>
Date: Tue, 30 Jun 2009 19:36:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Attila Kinali <attila@kinali.ch>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Long lasting MM bug when swap is smaller than RAM
References: <20090630115819.38b40ba4.attila@kinali.ch>
In-Reply-To: <20090630115819.38b40ba4.attila@kinali.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 03:58 AM, Attila Kinali wrote:
> Moin,
>
> There has been a bug back in the 2.4.17 days that is somehow
> triggered by swap being smaller than RAM, which i thought had
> been fixed long ago, reappeared on one of the machines i manage.
>
> <history>

It's quite unlikely what you are seeing is at all related to that 
problem. The VM subsystem has been hugely changed since then.

> root@natsuki:/home/attila# free -m
>               total       used       free     shared    buffers     cached
> Mem:          6023       5919        103          0        415       3873
> -/+ buffers/cache:       1630       4393
> Swap:         3812        879       2932
> ---
>
> I want to point your attention at the fact that the machine has now
> more RAM installed than it previously had RAM+Swap (ie before the upgrade).
> Ie there is no reason it would need to swap out, at least not so much.
>
> What is even more interesting is the amount of swap used over time.
> Sampled every day at 10:00 CEST:
>
> ---
> Date: Wed, 17 Jun 2009 10:00:01 +0200 (CEST)
> Mem:          6023       5893        130          0        405       3834
> Swap:         3812        190       3622

..

> As you can see, although memory usage didnt change much over time,
> swap usage increased from 190MB to 826MB in about two weeks.
>
> As i'm pretty much clueless when it commes to how the linux VM works,
> i would appreciate it if someone could give me some pointers on how
> to figure out what causes this bug so that it could be fixed finally.

You didn't post what the swap usage history before the upgrade was. But 
swapping does not only occur if memory is running low. If disk usage is 
high then non-recently used data may be swapped out to make more room 
for disk caching.

Also, by increasing memory from 2GB to 6GB on a 32-bit kernel, some 
memory pressure may actually be increased since many kernel data 
structures can only be in low memory (the bottom 896MB). The more that 
the system memory is increased the more the pressure on low memory can 
become. Using a 64-bit kernel avoids this problem.
