Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbYBTRFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbYBTRFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760323AbYBTRFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:05:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51633 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760311AbYBTRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:05:06 -0500
Message-ID: <47BC5DBD.5090702@garzik.org>
Date: Wed, 20 Feb 2008 12:05:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org,
       olof@lixom.net, sam@ravnborg.com
Subject: Re: [PATCH] Add PCI_DEVICE_TABLE macro
References: <1203250205-5103-1-git-send-email-jonas@southpole.se> <1203250404.24325.1.camel@satguru> <20080218044834.GB14184@kroah.com> <47B93512.6000107@southpole.se> <20080220161137.GB2658@kroah.com>
In-Reply-To: <20080220161137.GB2658@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Feb 18, 2008 at 08:34:42AM +0100, Jonas Bonn wrote:
>>> And again, what does this buy us?
>> Clarity and simplicity, I hope... there are a bunch of definitions 
>> scattered about the kernel that omit the __devinitdata modifier despite the 
>> documentation stating that it should always be there.  The definition 
>> really should have been const, which wasn't possible before but has become 
>> so with the addition of the __devinitconst attribute.
>>
>> Furthermore, there are definitions that use "const" and __devinitdata, 
>> which is explicitly wrong but the compiler doesn't catch section mismatches 
>> if there's only one such one case in the module (which is often the case).
>>
>> Adding the __devinitconst modifier where there was nothing before buys us 
>> memory.  Adding the const modifier gives the compiler a chance to do its 
>> thing.  Changing __devinitdata to __devinitconst where it was wrong 
>> actually fixes some compiler errors in older (mid-release) kernels that 
>> were patched over by "removing" the section attribute altogether (which 
>> wastes memory).
>>
>> Adding the macro (Olof's idea, not mine) makes it pretty difficult to get 
>> this definition wrong... I'll do the rest of the cleanup, but I need to 
>> know whether it's better to use a macro like this, or to open code the 
>> definitions.  I prefer the macro approach...
>>
>> Hope this makes some sense...
> 
> Ok, yes it does, thanks for the explaination.
> 
> Please, can you add this very good text to the changelog entry for the
> addition of the macro, and to the documentation somewhere?  I'd be glad
> to take the patch if that was done.

I would suggest having a DECLARE_ prefix in there, like other subsystems 
do...

	Jeff




