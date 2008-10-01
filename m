Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYJAMst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYJAMst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYJAMsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:48:41 -0400
Received: from smtp11.mtu.ru ([62.5.255.40]:65091 "EHLO smtp11.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYJAMsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:48:41 -0400
X-Greylist: delayed 677 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2008 08:48:40 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: How can i read really 512 byte?
To: Milton Miller <miltonm@bga.com>, janos.haar@netcenter.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 01 Oct 2008 16:36:32 +0400
References: <200809301450.m8UEo5wT027331@sullivan.realtime.net> <409101c923af$c8092020$0400a8c0@dcccs> <11424badd1aca3f1ec752f97c47f589b@bga.com>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20081001114428.DCCEB1723EF@smtp11.mtu.ru>
X-DCC-STREAM-Metrics: smtp11.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller wrote:

> 
> On Oct 1, 2008, at 5:23 AM, Janos Haar wrote:
> 
>>> On Tue, 30 Sep 2008 at 08:29:15 -0400 (EDT), Janos Haar wrote:
>>>> Now i am working on recover some data from one defective drive.  I
>>>> am using dd_rescue, and dd, but both ready only 4K, i think, because
>>>> the kernel's block size is 4K.
>>>> I have tried to google for the solution, but only found this trick:
>>>> losetup /dev/loop0 /dev/hdc
>>>> blockdev --setbsz 512 /dev/hdc
>>>> and after this set, trying to read the hdc...
>>>> It looks like working on the first look, but not really. :-( The
>>>> 512 size bad sectors still have 4K sizes, but the reading attempt
>>>> takes more (8x ?) longer.
>>>> Somebody can help me to set the reading block size to 512 byte?
>>> You need to add O_DIRECT to the open call in the flags parameter
>>> (the second argument).   (My brother tested this a year or so ago,
>>> and it worked for him).
>>> milton
>>
>> Hello,
>>
>> Thank you for the information.
>> Can you help me a little bit more?
>> Where need to add this parameter?
>> In the kernel, in the blocked's source, or in the dd_rescue's source?
> 
> dd_rescue ... there is a call to open, add O_DIRECT to the second
> argument and recompile.  If it says unknown identifier, just copy the
> #define from the kernel header into the dd_rescue source.
> 

C'mon, really.

{pts/0}% dd_rescue -h

dd_rescue Version 1.14, garloff@suse.de, GNU GPL
[...]
         -b softbs  block size for copy operation (def=65536),
         -B hardbs  fallback block size in case of errs (def=512),
[...]
         -d/D       use O_DIRECT for input/output (def=no),


