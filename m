Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYJBBnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYJBBnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYJBBm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:42:56 -0400
Received: from sandeen.net ([209.173.210.139]:29433 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYJBBmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:42:55 -0400
Message-ID: <48E4271D.1090203@sandeen.net>
Date: Wed, 01 Oct 2008 20:42:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed>
In-Reply-To: <20081002004556.GB30001@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> Adding xfs@oss.sgi.com to the cc list so all the XFS folk see this.
> 
> On Wed, Oct 01, 2008 at 10:38:22PM +0200, Tobias Frost wrote:
>> (Note: Please CC me, as I am NOT on the lkml!!)
>>
>> Some time ago, I discovered some problems with xfs. Unfortunatly, I had
>> no time diving into it. However, some weeks ago some other people
>> running debian on ARM machines confirmed the problem on their machines
>> starting at [1], so I think it is appropitate to at least report it.  
>> It has also been seen on 2.6.27-rc4  [2].
>>
>> summary: the xfs partition corrupts almost immediatly after creation. I
>> had the impression, that the first unlink (rm) causes the corruption,
>> but this might be just an impression.
>>
>> During the tests I made, I conserved a image of the corrupted filesystem
>> which I can make available on request (it's 26 Mbyte, gzipped).
>>
>> Please let me know how I can assist you in finding the problem. 
>>
>>
>> [1] http://lists.debian.org/debian-arm/2008/08/msg00155.html
>> [2] http://lists.debian.org/debian-arm/2008/08/msg00184.html
>>
>> Best regards,
>> Tobias Frost
>> http://blog.coldtobi.de
>>
>> PS: Thank you for your great work!

Ok, actually: first - sorry for the scattershot replies.  I thought
userspace was updated earlier, but:

xfsprogs-2.10.1 (5 September 2008)...
	- Add packed on-disk shortform directory for ARM's old ABI, thanks to
	  Eric Sandeen.

and the original kernel change:

    [XFS] Pack some shortform dir2 structures for the ARM old ABI
    architecture.
...
    Note that userspace needs a similar treatment, and any filesystems which
    were running with the previous rogue "fix" will now see corruption
...

So perhaps as a first easy test, can you please re-test with
xfsprogs-2.10.1 or newer.

Thanks,
-Eric
