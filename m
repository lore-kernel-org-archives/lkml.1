Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYAYKoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYAYKoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYAYKnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:43:53 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52496 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbYAYKnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:43:52 -0500
Date: Fri, 25 Jan 2008 12:42:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, trivial@kernel.org
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
	file
Message-ID: <20080125104217.GA6700@does.not.exist>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com> <Pine.LNX.4.61.0801242318560.8513@ginsburg.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0801242318560.8513@ginsburg.homenet>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:22:21PM +0000, Tigran Aivazian wrote:
> On Fri, 25 Jan 2008, Dmitri Vorobiev wrote:
>
>> Heikki Orsila пишет:
>>>> +extern void dump_imap(const char *, struct super_block *);
>>>> +
>>>
>>> Functions should not be externed, remove extern keyword.
>>>
>>
>> Care to explain why?
>
> because dump_imap() is just a BFS' internal helper (for debugging 
> purposes only btw) to dump the inode map via printk. Why should it be 
> moved into the header, i.e. where one expects to see things potentially 
> visible by the rest of the kernel?
>...

fs/bfs/bfs.h is not visible to the rest of the kernel, it's the right 
place for bfs-internal code.

Whether there's an "extern" written is just a syntax thing with zero 
semantical implications. We tend to not write the "extern" in the 
kernel, but that's nothing cast in stone.

But prototypes really belong into header files - bugs in this area are 
rare, but when they occur they can cause nasty hard-to-debug bugs
(e.g. depending on the calling convention on the architecture calling 
the function can turn your stack into garbage), and with the prototypes 
in header files gcc can do type checks.

> Kind regards
> Tigran

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

