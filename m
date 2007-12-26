Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbXLZSav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbXLZSav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 13:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXLZSan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 13:30:43 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:54027 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751001AbXLZSam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 13:30:42 -0500
Message-ID: <47729DCB.6010000@cfl.rr.com>
Date: Wed, 26 Dec 2007 13:30:35 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Lutomirski <luto@myrealbox.com>
CC: Theodore Tso <tytso@mit.edu>, David Newall <david@davidnewall.com>,
       John Reiser <jreiser@bitwagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <20071214201305.GL19691@waste.org>	 <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com>	 <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com>	 <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com>	 <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com>	 <476ACDBE.2070600@cfl.rr.com> <cb0375e10712210810p36fc9995s345d23b7dff5a3b3@mail.gmail.com>
In-Reply-To: <cb0375e10712210810p36fc9995s345d23b7dff5a3b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Dec 2007 18:31:00.0880 (UTC) FILETIME=[76F75100:01C847ED]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15630.000
X-TM-AS-Result: No--10.668900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski wrote:
> No, it's there, and if there's little enough entropy around it can be
> recovered by brute force.

A little entropy is enough to prevent a brute force attack.  You would 
have to have ZERO entropy after a cold boot so the attacker would know 
exactly the contents of the pool, AND know that one and ONLY one other 
task has read from /dev/urandom, AND exactly what time that task did so, 
AND how many bytes it read.  Only then could the attacker read from 
urandom and based on those bytes and the previous known pool state, 
brute force the 3 bytes that came from some unknown location in the 
other task's memory.

>>> Step 1: Boot a system without a usable entropy source.
>>> Step 2: add some (predictable) "entropy" from userspace which isn't a
>>> multiple of 4, so up to three extra bytes get added.
>>> Step 3: Read a few bytes of /dev/random and send them over the network.
>> Only root can do 1 and 2, at which point, it's already game over.
> 
> Again, no.  Root could do this accidentally.  Step 1 happens all the
> time (see the comments on non-unique UUIDs).  Step 2 just requires a

It does not happen all the time.  It happens on a system that has just 
been cold booted from read only distribution media with a broken cmos 
clock, no user keyboard interaction, and no hardware rng and that's it. 
  Every other system is going to have some entropy from the last boot at 
least.


