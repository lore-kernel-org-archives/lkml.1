Return-Path: <linux-kernel-owner+w=401wt.eu-S1764515AbYBZVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764515AbYBZVBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYBZVBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:01:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbYBZVBG (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:01:06 -0500
Message-ID: <47C47DB7.60102@sgi.com>
Date: Wed, 27 Feb 2008 07:59:35 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
Organization: SGI Engineering
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Christoph Hellwig <hch@lst.de>,
       xfs@oss.sgi.com, johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after	2.6.25-rc1
 (bisected, powerpc related?)
References: <20080225112310.GA5516@soziologie.ch> <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de> <200802260113.57875.rjw@sisk.pl> <20080226114419.GA5353@soziologie.ch> <47C47127.7040700@sandeen.net>
In-Reply-To: <47C47127.7040700@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eric Sandeen wrote:
> Gaudenz Steinlin wrote:
>> On Tue, Feb 26, 2008 at 01:13:56AM +0100, Rafael J. Wysocki wrote:
>>> On Tuesday, 26 of February 2008, Christoph Hellwig wrote:
>>>> On Tue, Feb 26, 2008 at 12:52:56AM +0100, Rafael J. Wysocki wrote:
>>>>>> I'm not suggesting a partial revert; I just wonder which part of the
>>>>>> change is causing the problem, as part of the debugging process.
>> I debuged this a bit further by testing the 4 changed functions
>> individually. The problem only occurs with the new version of
>> xfs_lowbit64.
>
> FWIW, Dave & I did some testing/debugging on 32-bit powerpc, and it is
> indeed only xfs_lowbit64 which is doing the wrong thing on that arch,
> because generic find_next_bit is doing the wrong thing on big-endian
> 32-bit systems, for sizes > 32 bits, near as I can tell.
>
> Rather than reverting it all, I think just changing xfs_lowbit64 back to:
> ...

Thanks Eric (and Dave), we'll look at your proposed fix. But for now,
the bit ops cleanup patch has been fully reverted, see Lachlan's earlier
mail and git pull request.

We're also expanding our internal h/w test matrix to include some
additional platforms to avoid this kind of thing in the future.

Cheers
-- Mark
