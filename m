Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbZE3PQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbZE3PQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 11:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZE3PQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 11:16:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53647 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744AbZE3PP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 11:15:58 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
	<4A210DEF.2030203@kernel.org> <m1d49qoi1o.fsf@fess.ebiederm.org>
	<1243693199.5223.5.camel@mulgrave.int.hansenpartnership.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 30 May 2009 08:15:53 -0700
In-Reply-To: <1243693199.5223.5.camel@mulgrave.int.hansenpartnership.com> (James Bottomley's message of "Sat\, 30 May 2009 14\:19\:59 +0000")
Message-ID: <m1bppaei52.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: James.Bottomley@HansenPartnership.com, ebiederm@aristanetworks.com, greg@kroah.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, tj@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Bottomley <James.Bottomley@HansenPartnership.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Sat, 2009-05-30 at 06:07 -0700, Eric W. Biederman wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>> > Eric W. Biederman wrote:
>> >>   Also, I'm quite uncomfortable with these things
>> >>> being done in non-atomic manner.  It can be made to work but things
>> >>> like this can lead to subtle race conditions and with the kind of
>> >>> layering we put on top of sysfs (kobject, driver model, driver
>> >>> midlayers and so on), it isn't all that easy to verify what's going
>> >>> on, so NACK for this one.
>> >> 
>> >> Total nonsense.
>> >> 
>> >> Mucking about with sysfs after we start deleting a directory is a bug.
>> >> At worst my change makes a buggy race slightly less deterministic.
>> >> 
>> >> I am not ready to consider keeping the current unnecessary atomic
>> >> removal step.  That unnecessary atomicity makes the following patches
>> >> more difficult, and requires a lot of unnecessary retesting.
>> >> 
>> >> What do you think the extra unnecessary atomicity helps protect?
>> >
>> > It's just not a clean API.  When people are trying to code things way
>> > up in the stack, they aren't likely to look up the code to see what
>> > assumptions are being made especially when the stack is deep and
>> > complex and sysfs is near the bottom of the tall stack.  IMHO
>> > implementing the usually expected semantics at this depth is worth
>> > every effort.  It's just good implementation style which might look
>> > like wasted effort but will harden the stack in the long run.  Plus,
>> > it's not like making it atomic is difficult or anything.
>> 
>> I guess we are going to have to disagree on this one.
>> 
>> My take is simply that a correct user has to wait until no one else
>> can find the kobject before calling kobject_del.  At which point
>> races are impossible, and it doesn't matter if sysfs_mutex is held
>> across the entire operation.
>
> I'm afraid this one isn't a valid assumption.  If you look in SCSI,
> you'll see we do get objects after they've been removed from visibility.
> We use it as part of the state model for how our objects work (objects
> removed from visibility are dying, but we still need them to be findable
> (and gettable).

I was not precise enough.  It appears I overlooked the fact that
kobject_del is not always called from kobject_put by way of
kobject_release.

Strictly the requirement is that after kobject_del we don't add,
remove or otherwise manipulate sysfs attributes.  That is we don't
call any of:

sysfs_add_file
sysfs_create_file
sysfs_create_bin_file
sysfs_remove_file
sysfs_remove_bin_file
sysfs_create_link
sysfs_remove_link
sysfs_create_group
sysfs_remove_group
sysfs_create_subdir
sysfs_remove_subdir


Those all either oops or BUG today if you try it.  So I can't see how
a subsystem could depend on those working.

Also there is sysfs_remove_dir (on a subdirectory) aka kobject_del on
a child object after kobject_del on the parent object.

As best I can tell that only works by fluke today.

> Now, this could be altered as part of an object lifetime rewrite of SCSI
> (and I suspect a few other subsystems) but it's certainly an open
> question of whether the pain is worth the gain.

I won't tell you that sysfs, the kobject layer, or the device layer
are the best thing since sliced bread.  I'm just trying to simplify
the code and get the bugs out.

Eric
