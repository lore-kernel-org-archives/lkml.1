Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbXLSWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbXLSWZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 17:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXLSWZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 17:25:12 -0500
Received: from mail.tmr.com ([64.65.253.246]:56037 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbXLSWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 17:25:10 -0500
Message-ID: <47699E82.5020503@tmr.com>
Date: Wed, 19 Dec 2007 17:43:14 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, David Newall <david@davidnewall.com>,
       Andy Lutomirski <luto@myrealbox.com>,
       John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <20071218030533.GN7070@thunk.org> <47673AD8.9010702@davidnewall.com> <20071218034656.GR7070@thunk.org> <476747DC.4040309@davidnewall.com> <20071218042337.GT7070@thunk.org>
In-Reply-To: <20071218042337.GT7070@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Dec 18, 2007 at 02:39:00PM +1030, David Newall wrote:
>> Thus, the entropy saved at shutdown can be known at boot-time.  (You can 
>> examine the saved entropy on disk.)
>>
> 
> If you can examine the saved entropy on disk, you can also introduce a
> trojan horse kernel that logs all keystrokes and all generated entropy
> to the FBI carnivore server --- you can replace the gpg binary with
> one which ships copies of the session keys to the CIA --- and you can
> replace the freeswan server with one which generates emphermal keys by
> encrypting the current timestamp with a key known only by the NSA.  So
> if the attacker has access to your disk between shutdown and boot up,
> you are *done*.   /dev/random is the least of your worries.
> 
> Really, why is it that people are so enamored about proposing these
> totally bogus scenarios?  Yes, if you have direct physical access to
> your machine, you can compromise it.  But there are far easier ways
> that such a vulnerability can be exploited, rather than making it easy
> to carry out an cryptoanalytic attack on /dev/random.
> 
> (And yes, after using the saved state to load the entropy at
> boot-time, the saved state file is overwritten, and if you're
> paranoid, you can scrub the disk after it is read and mixed into the
> entropy pool.  And yes, the saved state is *not* the entropy pool used
> during the previous boot, but entropy extracted using SHA-1 based
> CRNG.)
> 
>>> If you have a server, the best thing you can do is use a hardware
>>> random number generator, if it exists.  Fortunately a number of
>>> hardware platforms, such as IBM blades and Thinkpads, come with TPM
>>> modules that include hardware RNG's.  That's ultimately the best way
>>> to solve these issues.
>> Just how random are they?  Do they turn out to be quite predictable if 
>> you're IBM?
> 
> They use a noise diode, so they are as good as any other hardware
> random number generator.  Of course, you ultimately have to trust the
> supplier of your hardware not to do something screwy, and Thinkpads
> are now made by Lenovo, which has caused some US Government types to
> get paranoid --- but that's why the best way to do things is to get
> entropy from as many places as possible, and mix it all into
> /dev/random.  If any one of them is unknown to the attacker, he's stuck.  
> 
In another thread I believe I mentioned things an attacker can't know 
(unless your system is already compromised) like fan speed, CPU 
temperature, etc.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
