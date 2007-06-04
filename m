Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXFDXwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXFDXwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbXFDXwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:52:36 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:27865 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbXFDXwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:52:35 -0400
Message-ID: <4664A5C6.7020004@de.ibm.com>
Date: Tue, 05 Jun 2007 01:52:38 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1: __attribute__((weak)) considered harmful
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070602171425.GG5500@stusta.de> <20070604142212.c0b68d6a.akpm@linux-foundation.org>
In-Reply-To: <20070604142212.c0b68d6a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 2 Jun 2007 19:14:25 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
> 
>> statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch 
>> shows why __attribute__((weak)) is harmful because you don't see if a 
>> required non-weak implemtation is missing:
>>
>> In this case, the weak printk_clock() was renamed to timestamp_clock(), 
>> but the ARM and i386 implementations weren't renamed...
>>
> 
> printk_clock() is sched_clock() in disguise, and I'm not sure that making
> sched_clock() more widely available in this fashion is something that we
> want to do anyway.
> 
> Anyway, the statistics patches have just celebrated their first birthday
> and I don't see that they're getting sufficient momentum or interest to
> ever get into mainline so I think I'll drop them, sorry.

Andrew,
the lock contention statistics, which have been added to -mm recently, duplicate 
code that we have in the statistics patches. I think I can slim the lock 
tracking patches further down considerably (similar to my attempt at 
timerstats). I have a working prototype that is getting some polishing brushes. 
Would you like to wait how this goes?

As to timestamp_clock(): its useful for statistics, but still a minor feature. 
It would be unfortuante if that was the stumbling block for my patches. Am I 
right that the fix for the issue pointed at by Adrian is to rename those two 
occurrences of printk_clock()? Do you want me to submit a patch?

