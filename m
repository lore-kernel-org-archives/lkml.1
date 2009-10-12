Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZJLUT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZJLUT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZJLUTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:19:25 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:45363 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbZJLUTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:19:25 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 16:19:25 EDT
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: RE: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Topic: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Index: AcpJ/6FE0xhfIRwfRT+rZ9QOhF0ebwBi+82AAA3jUSD//7JUgIAAXx2g
Date: Mon, 12 Oct 2009 20:10:40 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E7B1C22@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
 <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012172953.GA10557@suse.de>
In-Reply-To: <20091012172953.GA10557@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Odd quoting style :(

We like to keep things lively :)

>> Based on our testing, the #pragma pack(push,1) can pack the data
>> correctly for the HyperV to use, but __attribute__((packed)) couldn't
>> do this right.
>
>Why?  What does gcc generate differently?  This should be identical.

It should, but in practice in this case it does not seem to behave the same
Way.

>> These data structures are moved by someone from the original file,
>> ChannelMessages.h, which contains structures used for messaging to
>> host.
>
>I moved them as they did not need to be in that file, right?

Moving them was not a problem.

>Ideally, we don't deal with packed structures at all, but with offsets
>in memory and pick out the proper fields and put them into new
>structures if you want to use them that way.  How hard would that be to
>do here instead?

It is something that I want to look at in the future. Our primary focus
Is to get the bug fixed. We cannot do the offset way in the time we
Have before 2.6.32 closes and still be comfortable we have gone through
The extensive testing cycle we do on our side.

>I still want to figure out what the real difference here is.  Especially
>as I removed a lot of the #pragma pack(push,1) lines from the hv code.
>If it really is different, all of those patches should be reverted,
>right?

Not sure yet if they need to be reverted, after we fixed this bug last week
We are getting another one, it was masked by the one we just fixed. 
We are checking into that right now;

	BUG: unable to handle kernel NULL pointer dereference at (null)


Thanks,

Hank.


