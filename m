Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYHGNqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYHGNqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHGNqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:46:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:47047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHGNqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:46:36 -0400
Date: Thu, 7 Aug 2008 15:46:34 +0200
From: Karsten Keil <kkeil@suse.de>
To: "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
Cc: benh@kernel.crashing.org, Sean MacLennan <smaclennan@pikatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080807134634.GA1450@pingi.kke.suse.de>
References: <85496C0905BB194FBDA1572571DBE95D0949FC36@FLBVEXCH01.versatel.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85496C0905BB194FBDA1572571DBE95D0949FC36@FLBVEXCH01.versatel.local>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 01:01:38PM +0200, Andreas.Eversberg wrote:
> please note that some cards require MEMIO. disabling it means disabling 
> card types. if there are other future access modes and bridges,
> they can be implemented and then be selected by the vendor and device ids.
> read, write and fifo read, write are functions,
> assigned to pointers at runtime. also wrapping (slightly) different hardware
> access is possible in the future. i think we should leave it like it is.
(Please break long lines)

No, disabling modes is a valid optimation for self compiled kernel versions,
which are for exact one hardware, yes for normal hardware you would not able
to meassure the difference, but for embedded systems it makes sense.
Of course this is nothing a distribution will use.

I think we should remove the indirect calls, they are not needed here, even if
here are other future  access methods. Modern CPUs are lot better in optimation
conditional branches so this cost much less as a indirect call. Note on a 
static call the cpu can prefetch the instructions for the call target as soon
it decodes the call itself - with a indirect call, it cannot start prefetching
until the address is calculated and loaded).

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
