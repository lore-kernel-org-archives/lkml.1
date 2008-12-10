Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYLJK30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYLJK30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYLJK3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:29:18 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:38002 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYLJK3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:29:18 -0500
Date: Wed, 10 Dec 2008 13:29:12 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <1795455197.20081210132912@emcraft.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Detlev Zundel <dzu@denx.de>, Wolfgang Denk <wd@denx.de>,
       Milton Miller <miltonm@bga.com>, Ilya Yanok <yanok@emcraft.com>
Subject: Re[2]: [PATCH] fork_init: fix division by zero
In-Reply-To: <20081210101745.GG28946@ZenIV.linux.org.uk>
References: <200812092044.40649.yur@emcraft.com> <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be> <503391615.20081210130113@emcraft.com> <20081210101745.GG28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hello Al,

On Wednesday, December 10, 2008 you wrote:

> On Wed, Dec 10, 2008 at 01:01:13PM +0300, Yuri Tikhonov wrote:

>> >> +     max_threads = mempages * PAGE_SIZE / (8 * THREAD_SIZE);
>> >                       ^^^^^^^^^^^^^^^^^^^^
>> >> +#endif
>> 
>> > Can't this overflow, e.g. on 32-bit machines with HIGHMEM?
>> 
>>  The multiplier here is not PAGE_SIZE, but [PAGE_SIZE / (8 * 
>> THREAD_SIZE)], and this value is expected to be rather small (2, 4, or 
>> so).

> x * y / z is parsed as (x * y) / z, not x * (y / z).

 Here we believe in preprocessor: since all PAGE_SIZE, 8, and 
THREAD_SIZE are the constants we expect it will calculate this.

 E.g. here is the result from this line as produced by cross-gcc 
4.2.2:

        lis     r9,0
        rlwinm  r29,r29,2,16,29
        stw     r29,0(r9)

 As you see - only rotate-left, i.e. multiplication to the constant.

 In any case, adding braces as follows probably would be better:

+     max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));

 Right ?

> Only assignment operators (and ?:, in a sense that a ? b : c ? d : e is
> parsed as a ? b : (c ? d : e)) are right-to-left.  The rest is left-to-right.



 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

