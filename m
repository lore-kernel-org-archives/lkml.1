Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYJAMTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYJAMTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYJAMTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:19:35 -0400
Received: from mercury.realtime.net ([205.238.132.86]:56313 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYJAMTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:19:35 -0400
In-Reply-To: <409101c923af$c8092020$0400a8c0@dcccs>
References: <200809301450.m8UEo5wT027331@sullivan.realtime.net> <409101c923af$c8092020$0400a8c0@dcccs>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <11424badd1aca3f1ec752f97c47f589b@bga.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: How can i read really 512 byte?
Date: Wed, 1 Oct 2008 07:22:12 -0500
To: "Janos Haar" <janos.haar@netcenter.hu>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2008, at 5:23 AM, Janos Haar wrote:

>> On Tue, 30 Sep 2008 at 08:29:15 -0400 (EDT), Janos Haar wrote:
>>> Now i am working on recover some data from one defective drive.  I
>>> am using dd_rescue, and dd, but both ready only 4K, i think, because
>>> the kernel's block size is 4K.
>>> I have tried to google for the solution, but only found this trick:
>>> losetup /dev/loop0 /dev/hdc
>>> blockdev --setbsz 512 /dev/hdc
>>> and after this set, trying to read the hdc...
>>> It looks like working on the first look, but not really. :-( The
>>> 512 size bad sectors still have 4K sizes, but the reading attempt
>>> takes more (8x ?) longer.
>>> Somebody can help me to set the reading block size to 512 byte?
>> You need to add O_DIRECT to the open call in the flags parameter
>> (the second argument).   (My brother tested this a year or so ago,
>> and it worked for him).
>> milton
>
> Hello,
>
> Thank you for the information.
> Can you help me a little bit more?
> Where need to add this parameter?
> In the kernel, in the blocked's source, or in the dd_rescue's source?

dd_rescue ... there is a call to open, add O_DIRECT to the second 
argument and recompile.  If it says unknown identifier, just copy the 
#define from the kernel header into the dd_rescue source.

milton

