Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZJCNXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZJCNXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZJCNXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:23:12 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:48935 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZJCNXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AvU1QqSLlSnItTn7AXeigpFtfaI3uYJ3bPTRHvOAiRCdqhRY99povCNvooxvdJxwcK
         LV0NEg6G3piHK0hF27zQZuSjz6syV1B3aQeewVGAEhcT8RPcyb1mhukL04A2WM4kq+jw
         JGtxZPLqkBeA8V+hUKHUWPsTMR2c6IUi7V6og=
MIME-Version: 1.0
In-Reply-To: <20091003104723.GC15919@elte.hu>
References: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com>
	 <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com>
	 <20091003104723.GC15919@elte.hu>
Date: Sat, 3 Oct 2009 15:23:15 +0200
Message-ID: <f6ca9fed0910030623m3cde192br7e1a3256b3cf7838@mail.gmail.com>
Subject: Re: sched regression introduced by NO_NEW_FAIR_SLEEPERS
From: drago01 <drago01@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       Chuck Ebbert <cebbert@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 12:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * drago01 <drago01@gmail.com> wrote:
>
>> On Sun, Sep 27, 2009 at 9:47 PM, drago01 <drago01@gmail.com> wrote:
>> > Hi,
>> >
>> > Chuck has backported some scheduler patches from 2.6.32 to the fedora kernel.
>> >
>> > I did the following test to test the new scheduler (cpu is a core i7
>> > 920 4 cores + HT).
>> >
>> > run 8 "md5sum /dev/urandom" task and try to use the desktop (compiz).
>> >
>> > The result was that moving windows or rotating the cube is very slow.
>> > (same happens with pure metacity but is is worse in compiz).
>> >
>> > Mounting debugfs and doing "echo NEW_FAIR_SLEEPERS > sched_features"
>> > results into a useable desktop while the 8 md5sum tasks are running
>> > (ie. the system behaves as if they where not running at all from an
>> > interactivity pov).
>> >
>> >
>> > P.S: please CC me when replying.
>> >
>>
>> With "NEW_FAIR_SLEEPERS" I can even run 100(!)  "md5sum" task without
>> any effect on interactivity. (still have not found a number of tasks
>> needed to make the system unresponsive as with 8 with
>> "NO_NEW_FAIR_SLEEPERS".
>
> Can you try the latest -tip tree please:
>
>  http://people.redhat.com/mingo/tip.git/README
>
> There we default to FAIR_SLEEPERS + GENTLE_FAIR_SLEEPERS - which should
> give much of the new-fair-sleepers advantage.

OK, with this kernel it works fine (can spam the system with md5sum
tasks and the desktop is still responsive).
Was able to use the system with 129 "md5sum /dev/urandom" running.
