Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYJBBSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYJBBSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYJBBRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:17:52 -0400
Received: from sandeen.net ([209.173.210.139]:29131 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYJBBRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:17:52 -0400
Message-ID: <48E4213E.9090508@sandeen.net>
Date: Wed, 01 Oct 2008 20:17:50 -0500
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

You could try undoing this:

/* ARM old ABI has some weird alignment/padding */
#if defined(__arm__) && !defined(__ARM_EABI__)
#define __arch_pack __attribute__((packed))
#else
#define __arch_pack
#endif

and just define __arch_pack to nothing unconditionally, to see if that's
what broke...

Or if someone can provide an xfs.ko, or point "pahole" at it yourself,
and see if xfs_dir2_sf_hdr, xfs_dir2_sf_entry, and xfs_dir2_sf look more
like

http://sandeen.net/xfs-diskformat/xfs-oldabi-arm-pahole-structs
or
http://sandeen.net/xfs-diskformat/xfs-oldabi-fixed-arm-pahole-structs

?

otherwise I will give this a whirl in the emulator again...

Thanks,
-Eric


