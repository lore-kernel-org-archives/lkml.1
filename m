Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZDPSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZDPSl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZDPSlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:41:18 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:65143 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbZDPSlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:41:17 -0400
Message-ID: <49E77B49.3020102@cs.columbia.edu>
Date: Thu, 16 Apr 2009 14:39:05 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kurz <gkurz@fr.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: C/R without "leaks"
References: <49E40662.2040508@cs.columbia.edu> <20090414163633.GE27461@x200.localdomain> <49E4D89D.9060903@cs.columbia.edu> <20090415195629.GD26994@x200.localdomain> <1239835337.6610.6.camel@bahia> <20090416161215.GA8505@x200.localdomain> <49E774B1.5060505@nortel.com>
In-Reply-To: <49E774B1.5060505@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chris Friesen wrote:
> Alexey Dobriyan wrote:
>> On Thu, Apr 16, 2009 at 12:42:17AM +0200, Greg Kurz wrote:
>>> On Wed, 2009-04-15 at 23:56 +0400, Alexey Dobriyan wrote:
>>
>>>> There are sockets and live netns as the most complex example. I'm not
>>>> prepared to describe it exactly, but people wishing to do C/R with
>>>> "leaks" should be very careful with their wishes.
>>> They should close their sockets before checkpoint and find/have some way
>>> to reconnect after. This implies some kind of C/R awareness in the code
>>> to be checkpointed.
>>
>> How do you imagine sshd closing sockets and reconnecting?
> 
> Don't you already have to handle the case where an sshd connection is
> checkpointed, then the system is shutdown and the restore doesn't happen
> until after the TCP timeout?

Any connection in that case is, of course, lost, and it's up to the
application to do something about it. If the application relies on
the state of the connection, it will have to give up (e.g. sshd, and
ssh, die).

However, there are many application that can withstand connection
lost without crashing. They simply retry (web browser, irc client,
db clients). With time, there may be more applications that are
'c/r-aware'.

Moreover, in some cases you could, on restart, use a wrapper to
create a new connection to somewhere (*), then ask restart(2) to
use that socket instead of the original, such that from the user
point of view things continue to work well, transparently.

(*) that somewhere, could be the original peer, or another server,
if it has a way to somehow continue a cut connection, or a special
wrapper server that you right for that purpose.

Oren.

