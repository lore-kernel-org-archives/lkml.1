Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYLJR5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYLJR5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYLJR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:56:56 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:40595 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYLJR4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:56:55 -0500
Date: Wed, 10 Dec 2008 20:56:51 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <527599002.20081210205651@emcraft.com>
To: Scott Wood <scottwood@freescale.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Wolfgang Denk <wd@denx.de>,
       Detlev Zundel <dzu@denx.de>, <linux-kernel@vger.kernel.org>,
       Milton Miller <miltonm@bga.com>, <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Ilya Yanok <yanok@emcraft.com>
Subject: Re[2]: [PATCH] fork_init: fix division by zero
In-Reply-To: <20081210172512.GA19584@ld0162-tx32.am.freescale.net>
References: <200812092044.40649.yur@emcraft.com> <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be> <503391615.20081210130113@emcraft.com> <20081210101745.GG28946@ZenIV.linux.org.uk> <1795455197.20081210132912@emcraft.com> <20081210172512.GA19584@ld0162-tx32.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Scott,

On Wednesday, December 10, 2008 you wrote:

> On Wed, Dec 10, 2008 at 01:29:12PM +0300, Yuri Tikhonov wrote:
>> On Wednesday, December 10, 2008 you wrote:
>> > x * y / z is parsed as (x * y) / z, not x * (y / z).
>> 
>>  Here we believe in preprocessor: since all PAGE_SIZE, 8, and 
>> THREAD_SIZE are the constants we expect it will calculate this.
>> 
>>  E.g. here is the result from this line as produced by cross-gcc 
>> 4.2.2:
>> 
>>         lis     r9,0
>>         rlwinm  r29,r29,2,16,29
>>         stw     r29,0(r9)
>> 
>>  As you see - only rotate-left, i.e. multiplication to the constant.

> Yes, and also note that it is masking the result by 0xfffc, to preserve
> the effect of any overflow in (x * y).

 Right, such a mask was the result of missed brackets. Now (see 
"[PATCH][v2] fork_init: fix division by zero" I've just posted) the 
situation is better:

        lis     r9,0
        rlwinm  r29,r29,2,0,29
        stw     r29,0(r9)

 I.e. the mask is 0xFFFFFFFC.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

