Return-Path: <linux-kernel-owner+w=401wt.eu-S1764890AbYBMKK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764890AbYBMKK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYBMKKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:10:11 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:47224 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYBMKKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:10:09 -0500
Message-ID: <47B2C1F4.5010403@cateee.net>
Date: Wed, 13 Feb 2008 11:09:56 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Miller <davem@davemloft.net>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org
Subject: Re: distributed module configuration
References: <20080212191552.GA20883@kroah.com> <20080212.164149.209357519.davem@davemloft.net> <20080213084541.GA8091@uranus.ravnborg.org> <20080213.005433.23276743.davem@davemloft.net> <20080213090451.GA8319@uranus.ravnborg.org>
In-Reply-To: <20080213090451.GA8319@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Feb 13, 2008 at 12:54:33AM -0800, David Miller wrote:
>> From: Sam Ravnborg <sam@ravnborg.org>
>> Date: Wed, 13 Feb 2008 09:45:41 +0100
>>
>>> So we could do:
>>>
>>> config foo
>>> 	tristate "do you want foo?"
>>> 	depends on USB && BAR
>>> 	module
>>> 	  obj-$(CONFIG_FOO) += foo.o
>>> 	  foo-y := file1.o file2.o
>>> 	help
>>> 	  foo will allow you to explode your PC
>>  ...
>>> Does this fit what you had in mind?
>> Yes it does.
>>
>> Now I'll ask if you think embedding this information in one of the C
>> files for a module would be even nicer?
> I have no good idea for the syntax and I and not sure what is gained
> by reducing a driver with one file.
> Agreed - simple drivers would then be a single file - and thats a good argument.

I like the Sam proposal, but maybe we can simplify the rules on
"module" segment: some informations are often redundant, dependencies
are sometime calculated by config part and sometime by Makefile
(and sometime in the Makefile there are some wrong hacks).
I would really like a good section like:

module
    foo : file1.o file2.o

and let the complex rules in the normal Makefile
(which is also good because the complex rules are often not
specific to a single driver).

But I don't like merging all info in a single file:
- not so clean in case of multiple source-file driver
- it would be more complex the "copy and paste"
   from other drivers: most developers are not
   comfortable with Kconfig and Makefile, so easy to grep
   others Kconfig/Makefile could help developers not do
   do strange/wrong hacks.

ciao
	cate

