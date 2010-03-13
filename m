Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab0CMDP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:15:29 -0500
Received: from mail-px0-f198.google.com ([209.85.216.198]:47136 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab0CMDP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=IkgeyWl77B9JxU53U7iYy2SQT5FzgV4pgrZ67c3AnjNJx/1tfDzZSArNx8PNGG5rw1
         cFJlVpaYh3nWPW36ON5cat3paoKyYlcSxYcl8x9AxSpOyKRwb9RQERhKK72b+rldNUx0
         uP3/YgR4Njks9+LLD9axVBMyMM9pOavGzFx5k=
MIME-Version: 1.0
In-Reply-To: <1268449748.4471.795.camel@gandalf.stny.rr.com>
References: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
	 <1268436844.4471.783.camel@gandalf.stny.rr.com>
	 <40ec3ea41003121812j7cb349e4g1c455ae096da35cd@mail.gmail.com>
	 <1268447444.4471.789.camel@gandalf.stny.rr.com>
	 <40ec3ea41003121850y44e08737mf0544c10f1193129@mail.gmail.com>
	 <1268449748.4471.795.camel@gandalf.stny.rr.com>
Date: Fri, 12 Mar 2010 22:15:27 -0500
X-Google-Sender-Auth: 8244a933d1171e33
Message-ID: <40ec3ea41003121915g13837ce4kcb859191f3b70b2d@mail.gmail.com>
Subject: Re: Using tracing_off() in __schedule_bug()
From: Chase Douglas <chase.douglas@canonical.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 10:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-03-12 at 21:50 -0500, Chase Douglas wrote:
>> On Fri, Mar 12, 2010 at 9:30 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> I was thinking that there may be times where you want to skip warnings
>> to trace real bugs. For example, there's a WARNING that you hit if
>> your resume takes too long. I may want to skip that warning for the
>> oops that occurs just after it. As a distro, we also want to be
>> flexible in our official kernels so we don't have to build special
>> ones when people hit bugs. It's not as though it would be very
>> difficult to design with a few priorities, so unless it's really
>> unnecessary I don't see why we shouldn't. The default would also fire
>> tracing_off in all cases, so most people wouldn't have to modify it
>> unless they hit a corner case.
>
> I'm fine with having a two layer. Stop tracing on bugs and/or on
> warnings. I would actually have disable on warnings be default off.
> There are too many kernel warnings that trigger too easily, having your
> resume warning be one of them.
>
> I'm still not sure we need a separate one for critical errors. A oops,
> panic and BUG should all be the same. Since any of them can cause the
> system to halt.

That sounds fine to me. I'll work on a patch for this.

-- Chase
