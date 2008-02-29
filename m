Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbYB2GU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbYB2GU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYB2GUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:20:15 -0500
Received: from c60.cesmail.net ([216.154.195.49]:32422 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYB2GUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:20:14 -0500
Message-ID: <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
Date: Fri, 29 Feb 2008 01:20:12 -0500
From: Pavel Roskin <proski@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
References: <1204236662.3612.6.camel@dv>
	<alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds <torvalds@linux-foundation.org>:

> On Thu, 28 Feb 2008, Pavel Roskin wrote:
>>
>> A change after 2.6.24 broke ndiswrapper by accidentally removing its
>> access to GPL-only symbols.  Revert that change and add comments about
>> the reasons why ndiswrapper and driverloader are treated in a special
>> way.
>
> I'm not seeing why ndiswrapper should be treated separately.

It is already treated separately, and has been for a long time.  Since  
ndiswrapper taints itself when it loads a proprietary NDIS module, I  
don't think any special treatment is needed anymore, but that's beyond  
my point.

All I'm trying to do it to revert a patch that, as its author  
admitted, had unexpected consequences:
http://kerneltrap.org/mailarchive/linux-kernel/2008/1/30/648044

> If it loads non-GPL modules, it shouldn't be able to use GPLONLY symbols.

This is not the original intention of GPLONLY.  GPLONLY exists to  
prevent loading of modules that are proprietary, but can be considered  
to be Linux derivatives due to their use of Linux specific API.

In case of ndiswrapper, there is no question that ndiswrapper is a  
Linux derivative, but it's under GPL.  Yet the proprietary modules are  
not Linux derivatives because they don't use Linux API.  In fact, they  
were never intended to run on Linux.

By using GPLONLY to exclude ndiswrapper, you would give GPLONLY an  
additional meaning, namely functions that are not available to  
ndiswrapper.

> So if ndiswrapper needs GPL-only symbols, you'd better ask the people who
> made those symbols GPL-only whether they could be made available to
> ndiswrapper.

That would mean that I would have to ask those symbols to be opened to  
proprietary Linux kernel modules as well, which is not my intention.

> ndiswrapper itself is *not* compatible with the GPL. Trying to claim that
> ndiswrapper somehow itself is GPL'd even though it then loads modules that
> aren't is stupid and pointless. Clearly it just re-exports those GPLONLY
> functions to code that is *not* GPL'd.

Simple re-exporting would be useless.  It's a wrapper that isolates  
NDIS API from Linux API.  Anything Linux specific is in ndiswrapper  
itself.  The proprietary modules call only NDIS functions.

I believe, the license is a choice of the copyright holders.  Apart  
from that, I don't feel qualified to discuss any legal matters.

-- 
Regards,
Pavel Roskin
