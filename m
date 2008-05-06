Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbYEFNyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbYEFNyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbYEFNx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:53:59 -0400
Received: from sandeen.net ([209.173.210.139]:31757 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607AbYEFNx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:53:58 -0400
Message-ID: <482062F5.9010402@sandeen.net>
Date: Tue, 06 May 2008 08:53:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Marco Berizzi <pupilla@hotmail.com>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper:
 page allocation failure. order:3, mode:0x4020)
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com> <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl>
In-Reply-To: <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizzi wrote:
> David Chinner wrote:
> 
>> Hmmmmm - interesting. Both the reports of this problem are from
>> machines running as squid proxies. Are you using AUFS for the cache?
> 
> no, I'm using cache_dir ufs with cache_replacement_policy heap LFUDA
> 
>> You've run repair, there's not much I can look at now.
>>
>> As a suggestion, when the cache gets close to full next time, can
>> you take a metadump of the filesystem (obfuscates names and contains
>> no data) and then trigger the cache cleanup function? If the
>> filesystem falls over, I'd be very interested in getting a copy of
>> hte metadump image and trying to reproduce the problem locally.
>> (BTW, you'll need a newer xfsprogs to get xfs_metadump).
> 
> could you please tell me the exact command to run
> when this happen again?

xfs_metadump /dev/hda8 /path/to/the/image/you/are/creating

will make a metadata image of the on device hda8 and store it in the
filename given on the 2nd argument.

The idea is to catch the metadata state shortly before the cache cleanup
triggers; this might lead to a reproducible testcase (sgi guys could
then restore the metadata image, simulate the cache cleanup, see what
happens).

Thanks,
-Eric

>> Still, thank you for the information
> 
> no problem: 2.6.25 is a bit unlucky for me :-((
> 
> 
> 
> 

