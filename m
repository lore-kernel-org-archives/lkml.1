Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYBHM0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYBHM0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbYBHM03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:26:29 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:1362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbYBHM02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:26:28 -0500
Message-ID: <47AC4A64.4090903@free-electrons.com>
Date: Fri, 08 Feb 2008 13:26:12 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       linux-kernel@vger.kernel.org, linux-tiny <Linux-tiny@selenic.com>
Subject: Re: [PATCH] sysctl: allow embedded targets to disable sysctl_check.c
References: <200802071438.58497.hs4233@mail.mn-solutions.de>	<20080207194735.35d87346.akpm@linux-foundation.org> <m13as3d9ae.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13as3d9ae.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 11:36 AM, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
>
>   
>> On Thu, 7 Feb 2008 14:38:58 +0100 Holger Schurig <hs4233@mail.mn-solutions.de>
>> wrote:
>>
>>     
>>> Disable sysctl_check.c for embedded targets. This saves about about 11 kB
>>> in .text and another 11 kB in .data on a PXA255 embedded platform.
>>>
>>>       
>> Nice improvement.  But iirc sysctl_check was overtly a temporary thing.
>> Eric, was that the intention?
>>     
>
> Well so far sysctl_check has been a remarkably effective little piece of code
> in catching a great many long over looked bugs.
>
> I do agree that the static tables are big.  My current inclination is to modify
> sys_sysctl so that it does a look up in the binary tables to find the ascii
> names and then sys_sysctl can lookup the information in the ascii tables.
>
> If we do that we can completely remove ctl_name form the external sysctl data
> structures, which should save us quite a bit of space and make it absolutely
> impossible to add a new binary name.  And with the current ability to compile
> out sys_sysctl the embedded folks would get their space savings.
>
> I believe the only tricky bit is there are a few places in the network code
> where we need to translate from ifindex to interface name.  Otherwise
> the mapping is fixed.
>
> No that isn't quite right.  Getting the binary to ascii translation for the
> values is also a bit tricky.
>
> As for the rest of the checks I don't know if they are that big.  If they
> are then an option to compile them out on embedded platforms where you
> know what you are doing makes sense.  At the same time sysctl has been so
> badly abused in the past, and so very many bugs have been over looked
> that I am extremely reluctant to disable simple sanity checks at
> registration time.
>
> If we can remove the need for sysctl users to implement the binary
> interface many of those checks go completely away as the reason for their
> existence would be gone.
>
> I have seen to many absolutely horrible things in the usage of the sysctl
> tables to be happy with an option that removes the sanity checks at this
> point, although the patch likely makes sense from a code size perspective.
>
> Let's see if we can find a bit of time to make those big tables completely
> specific to sys_sysctl and kill ctl_name in the kernel.  Long term that is
> a whole lot more maintainable, and smaller for everyone who can disable
> sys_sysctl.
>
> Eric
>   
Holger, this is a nice improvement allowing to keep /proc/sys but
reducing its size. Thanks! On x86, they save 9K in the text section and
12 K in data.

For those embedded system developers who are unfamiliar with this topic,
you can already completely remove the /proc/sys interface if you don't
need it. Then you save 19K of text and 16 k of data).

Copying the Linux-Tiny mailing list to draw the attraction of more
people to this discussion.

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

