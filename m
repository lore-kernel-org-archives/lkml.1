Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZJARBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZJARBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZJARBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:01:52 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48156 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbZJARBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:01:51 -0400
Message-ID: <4AC4E07E.8040707@natemccallum.com>
Date: Thu, 01 Oct 2009 13:01:50 -0400
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Exposing device ids and driver names
References: <4AC4DB65.8070404@natemccallum.com> <20091001164249.GA2715@kroah.com>
In-Reply-To: <20091001164249.GA2715@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 12:42 PM, Greg KH wrote:
> On Thu, Oct 01, 2009 at 12:40:05PM -0400, Nathaniel McCallum wrote:
>> Please CC me on any responses as I'm not subscribed to lkml.
>>
>> I have the aim at creating two tools helpful to linux.  The first tool
>> is a driver regression test of sorts.  I want to be able to create
>> essentially a time line of hardware support as they appear in distros.
>> The second tool, related to the first, is a program which runs on
>> Windows and scans for a user's hardware and tells them which distro will
>> best support their hardware.
>
> That's going to be interesting, as all distros pretty much use the same
> kernel, it will just depend on who is "newer" at the moment, right?

Mostly yes.  I intend to also trace id diffs against mainline to see if 
distros have picked up patches that are not upstream.

>> I already have a working prototype of these two tools.  It currently
>> uses the data exported by modinfo.  This however does not provide
>> transparency for drivers compiled into the kernel.
>
> Most distros don't build drivers into the kernel, so you should be fine
> with what you have today, right?  Or have you run into problems with
> this?

I've run into specific problems.  This is obviously the case on 
specialized distros (which I *do* want to measure).  However, even a 
quick diff on configs will show differences on major distros with some 
devices being compiled into the kernel.  It is also often true that ACPI 
devices are built into the kernel.

> Why not just use the baseline kernel as a model for this.  Do a 'make
> allmodconfig' and then extract the data and publish it that way.  No
> kernel changes are needed, and then any distro can be easily matched up
> by this based on what they are using.  That will save you time in
> downloading zillions of distro releases, and provide a nice easy way to
> show what the kernel.org releases support.

Unfortunately, I would not be able to track changes to the kernel in 
this model.  Since this is one of my explicit goals (to make sure that 
distro kernel changes get upstream), I think a non-invasive kernel 
modification would be worth the effort.

Nathaniel

