Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYHUMMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYHUMMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYHUMMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:12:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36587 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYHUMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:12:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48AD5A21.7020801@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 14:05:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>, jmerkey@wolfmountaingroup.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4	released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> <1219316568.8651.107.camel@twins> <20080821114745.GD21089@linux.vnet.ibm.com>
In-Reply-To: <20080821114745.GD21089@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Aug 21, 2008 at 01:02:48PM +0200, Peter Zijlstra wrote:
>> On Thu, 2008-08-21 at 12:57 +0200, Stefan Richter wrote:
>>> Peter Zijlstra wrote:
>>>> On Wed, 2008-08-20 at 20:50 -0600, jmerkey@wolfmountaingroup.com wrote:
>>>>
>>>>>  volatiles left in the code due to the previously stated
>>>>>  (and still present) severe breakage of the GNU compiler with SMP 
>>>>>  shared data.  most of the barrier() functions are just plain broken
>>>>>  and do not result in proper compiler behavior in this tree. 
>>>> Can you provide explicit detail?
>>>>
>>>> By using barrier() the compiler should clobber all its memory and
>>>> registers therefore forcing a write/reload of the variable.
>>> I hope Jeff didn't try mere barrier()s only.  smp_wmb() and smp_rmb()
>>> are the more relevant barrier variants for mdb, from what I remember
>>> when I last looked at it.
>> Sure, but volatile isn't a replacement for memory barriers.
> 
> Let's face it, the C standard does not support concurrency, so we are
> all in a state of sin in any case, forced to rely on combinations of
> gcc-specific non-standard language extensions and assembly language.
> 
> Could be worse!!!

Nevertheless, an analysis of which particular parts of code generation 
are insufficient if one particular volatile qualification is removed is 
IMO likely to turn up places in mdb where a clearer or/and more 
efficient implementation is possible.  (Based on what I saw a few 
revisions ago; I haven't looked at the current one yet.)
-- 
Stefan Richter
-=====-==--- =--- =-=-=
http://arcgraph.de/sr/
