Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbXK1LeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbXK1LeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbXK1LeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:34:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35999 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbXK1LeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:34:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Albert Cahalan <acahalan@gmail.com>,
       Guillaume Chazarain <guichaz@yahoo.fr>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl,
       roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	<20071128014901.4b303954@inria.fr>
	<787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	<20071128104622.GB19694@elte.hu>
Date: Wed, 28 Nov 2007 04:31:53 -0700
In-Reply-To: <20071128104622.GB19694@elte.hu> (Ingo Molnar's message of "Wed,
	28 Nov 2007 11:46:22 +0100")
Message-ID: <m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Albert Cahalan <acahalan@gmail.com> wrote:
>
>> On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:
>> > akpm@linux-foundation.org wrote:
>> >
>> > > We may be stuck with the current broken behavior for backwards
>> > > compatibility reasons but lets try fixing our ancient bug for the 2.6.25
>> > > time frame and see if anyone screams.
>> 
>> It's not broken. It's just not the feature you're looking for.
>
> well it's quite broken at the moment and we are looking for solutions 
> not for a blame game :-) You might have read the thread where i describe 
> what i had to go through to do something fairly trivial.

Yes.

In a lot of ways if you access /proc/self and you get back information
that does not correspond to yourself the result is nonsense.  Which
is a fairly mighty problem.

I'm still trying to understand which will break user space more,
adding /proc/task or changing /proc/self.

>> This one is probably best:
>> /proc/task -> 123/task/456
>> (with both numbers showing)
>
> this sounds good to me. If it's a symlink then there's not much other 
> choice because the thread PIDs do not even show up under /proc anymore.

The name sounds good to me.

I am not certain the two components make sense as we have a possible
permission problem where it is remotely possible that a task will
have permission to access /proc/<tid> but not /proc/<tgid>.

We certainly need to think through that case before making it
to a stable kernel.

The reason I care is that we need to fix /proc/mounts.  So once we
have /proc/task we can also have change /proc/mounts to
be a symlink to /proc/task/mounts. 

Once we get the /proc/mounts thing sorted out.  There are several
other entries in /proc that need to that need to follow in it's wake
as they also become per namespace.  /proc/net and /proc/sysvipc for
starters.

Eric
