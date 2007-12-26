Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbXLZUqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbXLZUqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXLZUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:45:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXLZUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:45:54 -0500
Message-ID: <4772BD6C.1010502@zytor.com>
Date: Wed, 26 Dec 2007 12:45:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Julia Lawall <julia@diku.dk>, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk> <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
In-Reply-To: <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Dec 26, 2007 7:21 AM, Julia Lawall <julia@diku.dk> wrote:
>> -               if (jiffies - ent->last_usage < timeout)
>> +               if (time_before(jiffies, ent->last_usage + timeout))
> 
> I don't think this is a safe change? subtraction is always safe (if
> you think about it as 'distance'), addition isn't always safe unless
> you know the range. The time_before macro will expand that out to
> (effectively):
> 
>   if ( (long)(ent->last_usage + timeout) - (long)(jiffies) < 0 )
> 
> which seems to introduce an overflow condition in the first term.
> 
> Dunno, I may be wrong (happens often), but at the very least what
> you've transformed it into is no longer obviously correct, and so it's
> not a great change.

Indeed.  The bottom form will have overflow issues at time 
jiffies_wraparound/2, whereas the top form will have overflow issues 
only near jiffies_wraparound/1.

	-hpa
