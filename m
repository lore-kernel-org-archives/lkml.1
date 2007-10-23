Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXJWJvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXJWJvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXJWJvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:51:38 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31749 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751760AbXJWJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:51:36 -0400
Message-ID: <471DC3D9.2070809@panasas.com>
Date: Tue, 23 Oct 2007 11:50:17 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk>
In-Reply-To: <20071023094142.GD5059@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 09:50:19.0532 (UTC) FILETIME=[1F3BECC0:01C8155A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007 at 11:41 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Oct 23 2007, Boaz Harrosh wrote:
>> On Mon, Oct 22 2007 at 23:47 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> On Mon, 22 Oct 2007, Alan Cox wrote:
>>>
>>>> For structures, not array elements or stack objects. Does gcc now get
>>>> aligned correct as an attribute on a stack object ?
>>> I think m68k stack layout still guarantees 4-byte-alignment, no?
>>>
>>>> Still doesn't answer the rather more important question - why not just
>>>> stick a NULL on the end instead of all the nutty hacks ?
>>> You still do need one bit for the discontiguous case, so it's not like you 
>>> can avoid the hacks anyway (unless you just blow up the structure 
>>> entirely) and make it a separate member). So once you have that 
>>> bit+pointer, using a separate NULL entry isn't exactly prettier. 
>>>
>>> Especially as we actally want to see the difference between 
>>> "end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
>>> anyway, you should probably use something like "all-ones".
>>>
>>> 			Linus
>>> -
>> Every one is so hysterical about this sg-chaining problem. And massive
>> patches produced, that when a simple none intrusive solution is proposed
>> it is totally ignored because every one thinks, "I can not be that stupid".
>> Well Einstein said: "Simplicity is the ultimate sophistication". So no one
>> need to feel bad.
> 
> It's all about the end goal - having maintainable and resilient code.
> And I think the sg code will be better once we get past the next day or
> so, and it'll be more robust. That is what matters to me, not the
> simplicity of the patch itself.
> 

But that is exactly what his patch is. Much more robust. Because you do not
relay on sglist content but on outside information, that you already have.
Have you had an hard look at his solution? It just simply falls into place.
Please try it out for yourself. I did, and it works.

Boaz


