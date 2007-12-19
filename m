Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbXLSUuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbXLSUuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbXLSUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:50:38 -0500
Received: from mail.tmr.com ([64.65.253.246]:55951 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbXLSUuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:50:37 -0500
Message-ID: <47698889.2080107@tmr.com>
Date: Wed, 19 Dec 2007 16:09:29 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] random: use xor for mixing
References: <2.753618428@selenic.com> <3.753618428@selenic.com> <20071209000103.GS17037@thunk.org> <20071209004017.GQ19691@waste.org> <20071209020828.GX17037@thunk.org>
In-Reply-To: <20071209020828.GX17037@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 06:40:17PM -0600, Matt Mackall wrote:
>> I'm working on strengthening forward security for cases where the
>> internals are exposed to an attacker. There are any number of
>> situations where this can and does happen, and ensuring we don't
>> expose ourselves to backtracking is a worthwhile theoretical concern.
> 
> See my other comments; I don't think we are currently vulnerable to
> backtracking.
> 
> I tend to view backtracking as largely a theoretical concern, as most
> of the time, if the attacker has read access to kernel memory in order
> to compromise the internal state of /dev/random, the attacker very
> likely has *write* access to kernel memory, at which point you have
> much bigger problems to worry about, at least going forward.  
> 
> I suppose if you had *just* generated an 80-bit AES session key, right
> before the internal state was compromised, this might be interesting,
> but if the attacker can compromise arbitrary kernel memory, then
> attacker might as well just grab keying information from the userspace
> process --- such as perhaps the long-term private key of the user, or
> the data to be encrypted.
> 
> So my personal take on it is that protecting against backtracking
> attacks is mainly useful in silencing academics who like to come up
> with, well, largely academic and theoretical scenario.  If it doesn't
> take much effort, sure, let's try to protect against it (and I think
> we're OK already).
> 
> But a much better use of our time would be spent creating userspace
> support so we can more efficiently pull entropy from TPM modules, or
> the noise from a sound/microphone input, etc., or other hardware
> sources of entropy.  That would provide a much more practical
> improvement to the /dev/random subsystem than worry about what I feel
> are largely academic concerns.

That doesn't actually sound too hard, and the sounds of passing traffic 
are not likely to be replicable in any case. Lots of sensor data might 
be used as well, fan rpm, etc. That sounds so obvious I can't believe 
there isn't a reason it's not being done.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
