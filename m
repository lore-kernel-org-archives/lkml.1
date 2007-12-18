Return-Path: <linux-kernel-owner+w=401wt.eu-S1765846AbXLRDNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765846AbXLRDNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXLRDNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:13:11 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38165 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbXLRDNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:13:10 -0500
Message-ID: <47673AD8.9010702@davidnewall.com>
Date: Tue, 18 Dec 2007 13:43:28 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andy Lutomirski <luto@myrealbox.com>,
       John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <20071218030533.GN7070@thunk.org>
In-Reply-To: <20071218030533.GN7070@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Dec 17, 2007 at 07:52:53PM -0500, Andy Lutomirski wrote:
>   
>> It runs on a freshly booted machine (no 
>> DSA involved, so we're not automatically hosed), so an attacker knows the 
>> initial pool state.  
>>     
>
> Not just a freshly booted system.  The system has to be a freshly
> booted, AND freshly installed system.  Normally you mix in a random
> seed at boot time.  And during the boot sequence, the block I/O will
> be mixing randomness into the entropy pool, and as the user logs in,
> the keyboard and mouse will be mixing more entropy into the pool.  So
> you'll have to assume that all entropy inputs have somehow been
> disabled as well. 
>   

On a server, keyboard and mouse are rarely used.  As you've described 
it, that leaves only the disk, and during the boot process, disk 
accesses and timing are somewhat predictable.  Whether this is 
sufficient to break the RNG is (clearly) a matter of debate.
