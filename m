Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbZL1RJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbZL1RJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZL1RJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:09:07 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:50760 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751894AbZL1RJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:09:06 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/5] arch/arm: Correct NULL test
Date: Mon, 28 Dec 2009 12:09:04 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F46E@mi8nycmail19.Mi8.com>
In-Reply-To: <Pine.LNX.4.64.0912281747570.6928@ask.diku.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] arch/arm: Correct NULL test
Thread-Index: AcqH3ftdfh8otKYeSvuF1bUQbDYOIQAAkr+A
References: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk><20091227215106.GA18317@pengutronix.de> <Pine.LNX.4.64.0912272307310.20548@ask.diku.dk> <BD79186B4FD85F4B8E60E381CAEE19090200F461@mi8nycmail19.Mi8.com> <Pine.LNX.4.64.0912281747570.6928@ask.diku.dk>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Julia Lawall" <julia@diku.dk>
Cc: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       <kernel-janitors@vger.kernel.org>, <linux@arm.linux.org.uk>,
       <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 28 Dec 2009 17:09:04.0488 (UTC) FILETIME=[755C2E80:01CA87E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 28, 2009 9:51 AM, Julia Lawall wrote:
> On Mon, 28 Dec 2009, H Hartley Sweeten wrote:
>
>> On Sunday, December 27, 2009 3:08 PM, Julia Lawall wrote:
>>>>>  	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
>>>>>  			     GFP_KERNEL);
>>>>> -	if (!dbgfs_state)
>>>>> +	if (!dbgfs_chan)
>>>>>  		goto err_alloc;
>>>> Shouldn't the malloc line read:
>>>> 
>>>> 	... = kmalloc(sizeof(*dbgfs_chan) * ...)
>>>> 	                      ^^^^^^^^^^
>>>> 
>>>> ?
>>>
>>> Good point, thanks.  I will send a revised patch.
>> 
>> Wouldn't this be clearer?
>> 
>> 	... = kmalloc(sizeof(struct dentry) * ...)
>
> Documentation/CodingStyle thinks otherwise:
>
> "The preferred form for passing a size of a struct is the following:
>
> 	p = kmalloc(sizeof(*p), ...);
>
> The alternative form where struct name is spelled out hurts readability 
> and introduces an opportunity for a bug when the pointer variable type is 
> changed but the corresponding sizeof that is passed to a memory allocator 
> is not."
>
> And actually, in this case, sizeof(struct dentry) would be wrong, because 
> the type of dbgfs_chan is struct dentry **, not struct dentry *.  What is 
> wanted is an array of pointers.

Ah, missed that.  Thanks for pointing it out.

Regards,
Hartley
