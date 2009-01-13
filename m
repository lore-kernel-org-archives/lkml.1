Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZAMRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZAMRW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZAMRVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:21:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZAMRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:21:48 -0500
Message-ID: <496CCD9B.7070308@redhat.com>
Date: Tue, 13 Jan 2009 11:21:31 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Arthur Jones <ajones@riverbed.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <494ADEB3.8010109@redhat.com> <20090112222834.GA25494@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090112222834.GA25494@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Hi Eric,
> 
>> Jan Kara wrote:
>>>   Hello,
>>>
>>>   I'm sorry I'm replying late but I got time to react to this only now...
>>>
>>>> I tried this and it too fixes the problem.  FWIW I agree it
>>>> looks better...
>>>   Well, shouldn't we rather fix what journal_start_commit() returns?
>>> The interface which returns 1 when a transaction is already committing or
>>> a transaction commit has just been started but 0 when we race with
>>> somebody staring the commit is fairly unusable. Moreover
>>> ext3_force_commit() will unnecessarily create new sync transaction and
>>> commit it if there's no transaction running which is quite expensive
>>> (even merging empty sync handle is not for free because of sync
>>> transaction batching). But this is minor problem since we probably
>>> don't care too much about sync() performance - BTW this is probably a
>>> cause for bug 12224, isn't it?
>> Yep, it is!  :)
>>
>>>   BTW: ocfs2 would need fixing as well if done your way since it's
>>> sync_fs function has been copied over from ext3.
>>>   To summarized I'd rather see a patch like below (untested) going in
>>> and your patch reverted... Opinions? I can cookup a JBD2 version of
>>> the patch in case we agree to go this way.
>> Thanks, I'll look that over.
>   Any chance you've looked over that patch? Thanks.
> 
> 								Honza

Sorry, kind of slipped through the cracks.  I'll do that and run it
through the testcase today.

-Eric
