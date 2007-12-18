Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbXLREIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbXLREIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXLREIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:08:42 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38191 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXLREIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:08:42 -0500
Message-ID: <476747DC.4040309@davidnewall.com>
Date: Tue, 18 Dec 2007 14:39:00 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, David Newall <david@davidnewall.com>,
       Andy Lutomirski <luto@myrealbox.com>,
       John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <20071218030533.GN7070@thunk.org> <47673AD8.9010702@davidnewall.com> <20071218034656.GR7070@thunk.org>
In-Reply-To: <20071218034656.GR7070@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Dec 18, 2007 at 01:43:28PM +1030, David Newall wrote:
>   
>> On a server, keyboard and mouse are rarely used.  As you've described it, 
>> that leaves only the disk, and during the boot process, disk accesses and 
>> timing are somewhat predictable.  Whether this is sufficient to break the 
>> RNG is (clearly) a matter of debate.
>>     
>
> In normal operaiton, entropy is accumlated on the system, extracted
> via /dev/urandom at shutdown, and then loaded back into the system
> when it boots up.

Thus, the entropy saved at shutdown can be known at boot-time.  (You can 
examine the saved entropy on disk.)


> If you have a server, the best thing you can do is use a hardware
> random number generator, if it exists.  Fortunately a number of
> hardware platforms, such as IBM blades and Thinkpads, come with TPM
> modules that include hardware RNG's.  That's ultimately the best way
> to solve these issues.

Just how random are they?  Do they turn out to be quite predictable if 
you're IBM?
