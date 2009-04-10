Return-Path: <linux-kernel-owner+w=401wt.eu-S1761221AbZDJLfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221AbZDJLfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbZDJLfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:35:09 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41389 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920AbZDJLfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vF/LOaiArzHXxlD2xv4sSXKabU/ny8amAOfvGbx+GQDguCBKyOMEtHPv/5FIX3E3i4
         OsnstidjyCbvkJFYsLjfIMmYwbRpJ86rpHriZqekNEYhFP5TnO80dKLIkrceZpFWSngk
         Lvbgo7Q9NgIqIVCa9luBT4x6rNWA7c8SIelwE=
Message-ID: <49DF2EE6.20203@tuffmail.co.uk>
Date: Fri, 10 Apr 2009 12:35:02 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Regression: First hibernation attempt fails
References: <49DDD83F.507@tuffmail.co.uk> <20090410092318.GB30093@elf.ucw.cz> <49DF289D.5070604@tuffmail.co.uk> <20090410112115.GA2513@elf.ucw.cz>
In-Reply-To: <20090410112115.GA2513@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2009-04-10 12:08:13, Alan Jenkins wrote:
>   
>> Pavel Machek wrote:
>>     
>>> On Thu 2009-04-09 12:13:03, Alan Jenkins wrote:
>>>   
>>>       
>>>> Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
>>>> wonder if it rings any bells?
>>>>
>>>> On my laptop (EEE 4G), the first attempt at hibernation fails. 
>>>> Subsequent attempts succeed.
>>>>
>>>> If I use s2disk as normal, I see "snapshotting system", then before it
>>>> gets to write out the image, it aborts and switches back to X.   I can't
>>>> see any error message, even if I check the log with "dmesg".
>>>>
>>>> If I use "echo disk > /sys/power/state", echo reports the error "Cannot
>>>> allocate memory".
>>>>
>>>> This only happens if I've logged in to X first.  In fact, I narrowed it
>>>> down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
>>>> then it doesn't happen.
>>>>         
>>> Anything interesting in dmesg?
>>>       
>> Nothing obvious. I've attached my latest at
>> <http://bugzilla.kernel.org/show_bug.cgi?id=13058>.
>>     
>
> Ok, next theory was that some module stuff is responsible (IIRC, from
> the lists). Can you try with everything-built-in (no modules) kernel?
> 									Pavel
>   

It's still present in v2.6.30-rc1-136-g62b8e68, which includes "module:
try_then_request_module must wait".

I don't think it's due to a missing module, because it doesn't happen if
I run "s2disk" from a console without logging in to KDE. I've put some
more details in Bugzilla about how it is reproduced (and what makes it
go away), it's a bit confusing.

But so long as I get the conditions right, it reproduces 100%. I'm going
to just try bisecting it - unless anyone has any more suggestions.

Thanks
Alan
