Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbZDBMan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbZDBMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZDBMaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:30:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:34864 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbZDBMaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:30:16 -0400
Message-ID: <49D4AFCA.1030405@tmr.com>
Date: Thu, 02 Apr 2009 08:30:02 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 pango-text SeaMonkey/1.1.15
MIME-Version: 1.0
To: david@lang.hm
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm> <49D3954A.9010309@tmr.com> <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm> <49D3DDBF.9060406@ursus.ath.cx> <alpine.DEB.1.10.0904011528100.28893@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0904011528100.28893@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Wed, 1 Apr 2009, Andreas T.Auer wrote:
>> Thank you, David, for this use case, but I think the problem could be
>> solved quite easily:
>>
>> At any write-out time, e.g. after collecting enough data for delayed
>> allocation or at fsync()
>>
>> 1) copy the metadata in memory, i.e. snapshot it
>> 2) write out the data corresponding to the metadata-snapshot
>> 3) write out the snapshot of the metadata
>>
>> In that way subsequent metadata changes should not interfere with the
>> metadata-update on disk.
>
> the problem with this approach is that the dcache has no provision for 
> there being two (or more) copies of the disk block in it's cache, 
> adding this would significantly complicate things (it was mentioned 
> briefly a few days ago in this thread)

I think the sync point should be between the file system and the dcache, 
with the data only going into the dcache when it's time to write it. 
That also opens the door to doing atime better at no cost, atime changes 
would be kept internal to the file system, and only be written at close 
or fsync, even on a mount which does not use noatime or relatime. The 
file system can keep that information and only write it when appropriate.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


