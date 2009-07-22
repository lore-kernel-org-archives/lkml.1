Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZGVT1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZGVT1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZGVT1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:27:50 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:50807 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZGVT1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TfSnYsH60aZWfaj3pSy8871zhe0RkYG6fJGyU0FPpZbUiBCCwBY7znFoSgwpWE0/nM
         J5HSXug6glu2HT+HAviT0GFtq8MBNTf4xz47Mt/XCmSCxhzG9WT2yXU3G/Yo5vNAbDtB
         3+7dSlL8zyw0FRFttKRWxpMMm0EddESu9nZZM=
MIME-Version: 1.0
In-Reply-To: <20090227154220.7099f339.akpm@linux-foundation.org>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200902271358.46863.david-b@pacbell.net>
	 <20090227141212.a2bc4a01.akpm@linux-foundation.org>
	 <200902271520.56696.david-b@pacbell.net>
	 <20090227154220.7099f339.akpm@linux-foundation.org>
Date: Thu, 23 Jul 2009 00:57:48 +0530
Message-ID: <5d5443650907221227w72768b3cna145cea00f1baa05@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: twl4030: add twl4030-pwrbutton as our child
From: Trilok Soni <soni.trilok@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew/Samuel,

On Sat, Feb 28, 2009 at 5:12 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Fri, 27 Feb 2009 15:20:56 -0800
> David Brownell <david-b@pacbell.net> wrote:
>
>> On Friday 27 February 2009, Andrew Morton wrote:
>> > > >
>> > > > What has gone wrong here?
>> > >
>> > > Not much I can see. __It's registering a platform_device,
>> > > but only if it could be used on this system.
>> >
>> > Again, that all gets fixed if this is done the right way around. __Run
>> > your probe function. __If the hardware is there, register with the core
>> > and all the nodes appear. __If the hardware is not present: bale.
>>
>> Right.  If there's no button hooked up to its "power button"
>> signal, don't register that "twl4030-pwrbutton" node.
>>
>>
>> > The design of the whole subsystem appears to be upside down :(
>>
>> You seem to be missing something.  Is it only the lack of that
>> tweak Felipe sent?
>
> I generally just delete unchangelogged patches.
>
> <goes back and finds it>
>
>
> That doesn't address the problem at all.  A function called
> "add_children" just shouldn't exist.  The general kernel design is for
> client drivers to register themselves with the core, so the core does
> not have any hard-wired knowledge of any client drivers.
>
> IOW, twl4030_pwrbutton_probe() should call into twl4030-core,
> registering the powerbutton driver.
>

Reviving this very old thread.

Andrew,

It seems that every driver under "mfd" is following the more or less
approach like twl4030, where the core driver is creating sub-device
driver's platform devices based on either some conditions like
platform data for that sub-device driver is available or not, or
sub-device array with it's "name" and "id" is passed from arch/ board
files.

Samuel,

I don't see any further discussion of points raised by Andrew in this driver.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
