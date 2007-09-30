Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXI3RqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXI3RqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbXI3RqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:46:08 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:22447 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755914AbXI3RqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:46:06 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 13:46:06 EDT
Message-ID: <46FFDCEF.20404@manicmethod.com>
Date: Sun, 30 Sep 2007 13:29:19 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <200709301042.26473.ak@suse.de>
In-Reply-To: <200709301042.26473.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2007 17:29:47.0867 (UTC) FILETIME=[7FBDC2B0:01C80387]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> - hm, netlabels.  Who might be a suitable person to review that code?
>>   Seems that Paul Moore is the man.  Maybe he'd be interested in taking a
>>   look over it (please?)
>>     
>
> I personally consider these IP options it uses to be pretty useless. Who could 
> ever use that without cryptographic authentication? Clearly when they 
> were designed in the original IP spec long ago the designers didn't understand
> network security very well because the whole field was at its infancy. And 
> CIPSO doesn't solve any of these fundamental issues.
>
> It assumes a trusted network which is a very dangerous assumption.  I don't 
> think that was in the original patch I looked at, I surely would have 
> objected to it.
>
> Perhaps take the network part out? I guess SMACK would be useful
> locally even without questionable network support.
>   

CIPSO is supported on SELinux as well. It certainly has uses where IPSec 
is excessive. One example is someone I talked to recently that basically 
has a set of blade systems connected with a high speed backplane that 
looks like a network interface. CIPSO is useful in this case because 
they can't afford the overhead of IPSec but need to transfer the level 
of the connection to the other machines. The backplane is a trusted 
network and that isn't a dangerous assumption in this case.

CIPSO also lets systems like SELinux and SMACK talk to other trusted 
systems (eg., trusted solaris) in a way they understand. I don't 
regularly support CIPSO as I believe IPSec labeling is more useful in 
more situations but that doesn't mean CIPSO is never useful.

