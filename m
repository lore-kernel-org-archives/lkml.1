Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYKDQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYKDQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbYKDQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:58:56 -0500
Received: from rtr.ca ([76.10.145.34]:57325 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbYKDQ6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:58:55 -0500
Message-ID: <49107F76.60107@rtr.ca>
Date: Tue, 04 Nov 2008 11:59:34 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <20081104062734.GA4420@havoc.gtf.org> <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org> <200811041753.53342.rjw@sisk.pl>
In-Reply-To: <200811041753.53342.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 4 of November 2008, Linus Torvalds wrote:
>> On Tue, 4 Nov 2008, Jeff Garzik wrote:
>>> This adds code at a late stage (heading towards -rc4), but does
>>> eliminate a particular spin-up overcycling behavior associated with
>>> hibernation.
>> What does this have to do with hibernation? 
>>
>> If it's a hibernation-only issue, then there is something wrong. 
> 
> No, it is not.  On some machines it is a power-off issue, on the others it is
> hibernation and power-off issue.
> 
>> Also, if it is an issue for normal power-off as well, then I wonder why 
>> this isn't an issue on Windows. Does windows not spin down disks at all?
> 
> In fact, AFAICS, it is an issue on Windows as well, at least if
> other-than-HP-preloaded version of Windows is used.
> 
>> IOW, I really don't think this is correct. 
>>
>> I _do_ think that correct might be:
>>
>>  - maybe we just do something odd and different, triggering some BIOS 
>>    behavior that isn't there under Windows.
>>
>>    So we should power down thigns differently so that the BIOS.
>>
>>  - quite possibly: we just should not spin down disks at all, and just 
>>    flush them and do the "park" command thing. If we're _really_ powering 
>>    off, the disks will spin down on their own when power goes away. Maybe 
>>    that's what Windows does?
>>
>> So I really don't want to pull this, because I want to get more of an 
>> explanation for why we need to do this at all. I also don't think this is 
>> even appropriate at this stage in -rc.
>>
>> Is it a regression? If so, that just strengthens the questions above - 
>> what did _we_ start doing wrong that this is needed at all? Let's just 
>> stop doing that, not add some idiotic black-list for somethign that _we_ 
>> do wrong.
> 
> This is a regression, but from something like 2.6.25 or even earlier.
> I think what happened is we started to power-off disks at one point and these
> BIOS-es just don't like that.
> 
> [Note that the issue only appears in _some_ HP boxes, other vendors don't
> seem to be affected at all.]
..

So, what happens if we just don't ever spin them down from the kernel?
Presumably they still spin-down normally (HP or otherwise) when the BIOS
actually cuts the power at the end of all of this?

Just curious..
