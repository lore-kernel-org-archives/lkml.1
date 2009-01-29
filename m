Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZA2UG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZA2UG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZA2UGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:06:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44497 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZA2UGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:06:17 -0500
Message-ID: <49820C11.3070202@redhat.com>
Date: Thu, 29 Jan 2009 15:05:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Arthur Jones <ajones@riverbed.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
References: <4908C951.2000309@redhat.com>	 <20081103184426.GA31894@ajones-laptop.nbttech.com>	 <20081103113318.35b0c266.akpm@linux-foundation.org>	 <20081103201428.GB30565@ajones-laptop.nbttech.com>	 <20081218231707.GB20092@atrey.karlin.mff.cuni.cz>	 <496D1233.2060905@redhat.com> <20090114042402.GH14730@mit.edu>	 <20090114172750.GJ19950@duck.suse.cz> <170fa0d20901291027g601c8674o9ec5daf67d4ad0de@mail.gmail.com>
In-Reply-To: <170fa0d20901291027g601c8674o9ec5daf67d4ad0de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:
> On Wed, Jan 14, 2009 at 12:27 PM, Jan Kara <jack@suse.cz> wrote:
>> On Tue 13-01-09 23:24:02, Theodore Tso wrote:
>>> On Tue, Jan 13, 2009 at 04:14:11PM -0600, Eric Sandeen wrote:
>>>> This looks sane to me, and it does fix the below testcase.
>>>>
>>>> Care to formally propose it?
>>> Can we confirm what is being proposed?  From following this thread, I
>>> think what folks are suggesting is:
>>>
>>> 1)  Revert the current "ext3/4: wait on all pending ocmmits in ext3/4_sync_fs"
>>  Yes.
>>
>>> 2)  Apply Jan's patch "jbd[2]: Fix return value of journal_start_commit()"
>>  Yes.
>>
>>> 3)  Also apply Jan's patch "jbd2: Skip commit of a transaction without
>>> any buffers" since it appears to be a good optimization (although it's
>>> not clear it would happen once we revert (1), above.
>>  Yes, it's an optimization but I'm still a bit afraid about something
>> relying on jbd2_journal_force_commit() implying a barrier which would not
>> always be a case after this patch... So we should probably audit all users of
>> ext4_force_commit() and check that this change is fine with them.
> 
> Ted/Jan/Eric,
> 
> I just wanted to followup on this to see what the plan is.  Items 1
> and 2 haven't occurred in any of the ext4.git branches that I can see.
>  I could be missing something but it seems this may have slipped
> through the ext[34] cracks?

Hm, I agree.

Jan, do you want to re-send it in its own message rather than buried in
the other thread?  I don't know how we technically handle a "revert"
upstream, to be honest.

-Eric
