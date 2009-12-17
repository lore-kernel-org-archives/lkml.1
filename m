Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbZLQTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbZLQTYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbZLQTYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:24:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:37499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965392AbZLQTYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:24:19 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/mIe1fv/TmJezvazbLVLHmyLm3whEmeELr0QDu2s
	CZ+NriESc79xBQ
Message-ID: <4B2A855C.8080003@gmx.de>
Date: Thu, 17 Dec 2009 20:24:12 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Julia Lawall <julia@diku.dk>, JosephChan@via.com.tw,
       Scott Fang <ScottFang@viatech.com.cn>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/9] drivers/video: Correct code taking the size of a
 pointer
References: <Pine.LNX.4.64.0912131242240.24267@ask.diku.dk>	<4B24E3AB.9040609@gmx.de> <20091213114343.a60828d3.akpm@linux-foundation.org>
In-Reply-To: <20091213114343.a60828d3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

thanks for your comment (and for taking the patch).
You can count it as Acked-by:me as it is technically correct. I also 
tested it but as I don't know any program that uses this interface (and 
not wanting to write my own as I do not want to encourage anyone to use 
this interface) I can't say whether it now works as intended.
However this patch is certainly a step in the right direction as writing 
random numbers to hardware is rarely correct :-)

Andrew Morton schrieb:
> On Sun, 13 Dec 2009 13:52:59 +0100 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> Hi Julia, Andrew,
>>
>> Julia Lawall schrieb:
>>> From: Julia Lawall <julia@diku.dk>
>>>
>>> sizeof(viafb_gamma_table) is just the size of the pointer.  This is changed
>>> to the size used when calling kmalloc to initialize the pointer.
>> this is the second patch addressing this issue ending up in my mailbox. 
>> At least this one is technically correct so feel free to upstream it.
>> However I vote for removing this ioctl hell from viafb as most of them 
>> duplicate framebuffer functionality or have unknown (not clearly 
>> defined) functionality or at least solve a generic problem with a custom 
>> ioctl (which I consider bad). I had a patch ready to move this stuff to 
>> an extra file and print a warning that it is subject to be removed. I 
>> feel a bit uncomfortable about repairing broken stuff prior to removing it.
>> Any comments on this subject?
>>
> 
> I favour both repairing and removing broken stuff ;)
> 
> We may as well fix it if problems are known.  Perhaps someone is
> hitting the problem at runtime in an older kernel and needs a patch to
> backport.  Perhaps we later decide to revert the removal, thus
> reinstating the known bug.

You are right.
I'll try to send a patch that at least labels these ioctls 
unstable/depreciated as soon as time permits so that nobody will start 
using them.


Regards,

Florian Tobias Schandinat
