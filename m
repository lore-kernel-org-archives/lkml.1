Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXBOXpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXBOXpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932855AbXBOXpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:45:41 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:61231 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932857AbXBOXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:45:39 -0500
In-Reply-To: <20070215223356.GA7880@uranus.ravnborg.org>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org> <20070215223356.GA7880@uranus.ravnborg.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A46E6EB1-4687-43BA-8DE9-BBAE7BD0D160@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: kbuild question
Date: Thu, 15 Feb 2007 17:44:42 -0600
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15, 2007, at 4:33 PM, Sam Ravnborg wrote:

> On Thu, Feb 15, 2007 at 01:18:52PM -0600, Kumar Gala wrote:
>> I was wondering if there was some way to make a Kconfig menu either
>> be just a menu or a choice depending on another bool being set or  
>> not.
>>
>> What I'm trying to accomplish is if CONFIG_ONLY_HAVE_ONE is set I
>> want it so you can only select on option, however if
>> CONFIG_ONLY_HAVE_ONE is not set you should be able to select multiple
>> options.
>
> You can do so using if.
> See following example:
> --------------------------------------------------------------
> config ONLY_HAVE_ONE
> 	prompt "only have one?"
> 	boolean
>
> if ONLY_HAVE_ONE
> config FOO
> 	bool foo
> 	default y
> endif
>
> if !ONLY_HAVE_ONE
> choice
> 	prompt "multiple values"
> 	default VAL_FIRST
>
> config VAL_FIRST
> 	bool "First value"
>
> config VAL_SECOND
> 	bool "Second value"
> endchoice
>
> endif
> --------------------------------------------------------------
>
> You should be able to modify this for the usage you ask for.
>
> Hope this is useful,

It is.

Now is there some way to not have to duplicate the 'config choices  
between if ONLY_HAVE_ONE and if !ONLY_HAVE_ONE

To use your example I want to do:

config ONLY_HAVE_ONE
	prompt "only have one?"
	boolean

if ONLY_HAVE_ONE
config VAL_FIRST
	bool "First value"

config VAL_SECOND
	bool "Second value"
endif

if !ONLY_HAVE_ONE
choice
	prompt "multiple values"
	default VAL_FIRST

config VAL_FIRST
	bool "First value"

config VAL_SECOND
	bool "Second value"
endchoice

endif

I'd like not to have to repeat/duplicate VAL_FIRST, VAL_SECOND, etc..

- k
