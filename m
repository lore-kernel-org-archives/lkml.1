Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYKYPzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYKYPzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYKYPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:54:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:32727 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYKYPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=inf/fCcI4wq1w5CGB3P3wGeexngH+IE+zq868dMn3IUtqfwxhQOfx9iHnOapbufWPp
         /J5cROHcef1G+fKguEKX4J0F9DWEQDEsBybc3J9No4OW8mrJ/8bzvxYMMQs2ot0MPFHW
         5+rwUOL8cJTnlylbStJQAw24FkdUmp0DWH79I=
Message-ID: <cfd18e0f0811250754x599d5284k6e9372a7b7af347@mail.gmail.com>
Date: Tue, 25 Nov 2008 10:54:49 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Current state of CLONE_NEWUSER?
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru
In-Reply-To: <20081121150710.GA10705@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0811191204r4ccaeaf4m4145e67f408543e0@mail.gmail.com>
	 <m1vdujdvi6.fsf@frodo.ebiederm.org>
	 <cfd18e0f0811200349q788c2767i5164dc1c47e67925@mail.gmail.com>
	 <m1zlju9u9z.fsf@frodo.ebiederm.org>
	 <20081121150710.GA10705@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Fri, Nov 21, 2008 at 10:07 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Michael Kerrisk" <mtk.manpages@googlemail.com> writes:
>>
>> > Hi Eric,
>> >
>> > On Wed, Nov 19, 2008 at 8:41 PM, Eric W. Biederman
>> > <ebiederm@xmission.com> wrote:
>> >> "Michael Kerrisk" <mtk.manpages@googlemail.com> writes:
>> >>
>> >>> Hi Serge,
>> >>>
>> >>> What is the current status of CLONE_NEWUSER?  I'm currently trying to
>> >>> test this flag in preparation for documenting it in the clone(2) man
>> >>> page, but am running into an ENOMEM error from the clone() call, which
>> >>> seems to occur after a failure in kobject_init_and_add() in the
>> >>> following call sequence:
>> >>>
>> >>> clone_user_ns() --> alloc_uid() --> uids_user_create() -->
>> >>> kobject_init_and_add()
>> >>>
>> >>> Are there already some test programs somewhere?  Is there any
>> >>> documentation already available for this flag?
>> >>
>> >> This code is definitely still under development.
>> >>
>> >> When complete it should be able to create a new uid namespace,
>> >> as an unprivileged user.  Creating a new process with uid == gid == 0.
>> >> Have a full set of caps.  And have permission to do nothing on the system
>> >> except read world readable files and write world writable files.
>> >
>> > Thanks for the info,
>> >
>> > So the error I described is expected?
>>
>> I don't think so.  Serge?
>
> I suspect you have the fair scheduler compiled in
> (CONFIG_FAIR_GROUP_SCHED).

True.

> So when you create a new user namespace, it
> tries to create a new /sys/kernel/uids/0 (or thereabouts) directory
> which sysfs refuses.

Okay.

> The fix for this was rolled in as the last patch in the rejected large
> network namespace/sysfs rework.  So we'll need another fix.  I suspect
> following the same path as we did for making network namespaces work is
> the best path for now.  (This being my last day of a week-long vacation
> I won't be sending a patch today :)

Yep, I saw your patch, thanks.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
