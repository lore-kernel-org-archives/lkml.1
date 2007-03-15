Return-Path: <linux-kernel-owner+w=401wt.eu-S1422894AbXCOPXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422894AbXCOPXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422895AbXCOPXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:23:08 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:48593 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422894AbXCOPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:23:07 -0400
In-Reply-To: <20070218192535.GA2425@uranus.ravnborg.org>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org> <Pine.LNX.4.64.0702161121540.14458@scrub.home> <9AF725F4-FE65-4357-B7EB-CC03808C105D@kernel.crashing.org> <Pine.LNX.4.64.0702181811220.14457@scrub.home> <20070218192535.GA2425@uranus.ravnborg.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <92E19AC8-F1D4-48AC-85DF-B59FE2F37CD4@kernel.crashing.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: kbuild question
Date: Thu, 15 Mar 2007 10:22:15 -0500
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18, 2007, at 1:25 PM, Sam Ravnborg wrote:

>>>
>>> Sure, on powerpc for some of the embedded sub-architectures you  
>>> can only
>>> select a single board to build for.  For a lot of people this is  
>>> sufficient,
>>> however we are moving towards a world where you can easily build  
>>> in support
>>> for multiple boards into a single kernel.
>>>
>>> I'd like to have it such that if I'm only building support for  
>>> one board
>>> (CONFIG_ONLY_HAVE_ONE, not going to call it that, but for this  
>>> discussion its
>>> sufficient), you get a choice menu from Kconfig enforcing the  
>>> ability to only
>>> select one board.  However if !CONFIG_ONLY_HAVE_ONE than you can  
>>> select
>>> multiple boards to build into your kernel.
>>>
>>> if CONFIG_ONLY_HAVE_ONE is set we can optimize out the runtime  
>>> checks that get
>>> added for handling the multiple board case.
>>
>> On m68k we have the same problem, but what I'm what I'm  
>> considering is to
>> add a new mode for choice groups - at least one must be selected and
>> kconfig generates the extra information if only one is selected.
>
> How about extendign the current 'option' syntax to do this?
> So we could do something like:
>
> choice
> 	prompt "choice prompt"
> 	default VAL_FIRST
> 	option multivalue if !CONFIG_ONLY_HAVE_ONE
>
> config VAL_FIRST
> 	bool "first"
>
> config VAL_SECOND
> 	bool "second"
>
> endchoice
>
> It seems to fit well with how option is used today, and extends  
> current
> syntax nicely.

This works for me, however I dont have the first clue about hacking  
on kconfig code.

I'm happy to test out a patch if one of you guys wouldn't mind  
working something up.. or point me and what I should look at to do this.

- k
