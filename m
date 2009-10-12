Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbZJLTeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbZJLTeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZJLTeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:34:09 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59667 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbZJLTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Wwmz7IuSqr/wfG3qWwY3dCj5U2vD36Bnndwrptb6obi8YmvYxJj7Tzv1yNImdeGv48
         o6EXxdY4Nf3/4rVtMUaA9INKN6WFC8bfAj9jEfVYYAAYRcpyUdi6Cr0bP6XPWxiWbRLs
         uTUO0zfXYoI+llX5y4soMZj6qSvJx+lykbUoQ=
MIME-Version: 1.0
In-Reply-To: <20091013031853.C744.A69D9226@jp.fujitsu.com>
References: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com> 
	<3e8340490910100011u17497293o613334c64f1543c8@mail.gmail.com> 
	<20091013031853.C744.A69D9226@jp.fujitsu.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 12 Oct 2009 15:33:11 -0400
Message-ID: <3e8340490910121233j17ebeb85m69e18566978b5ba2@mail.gmail.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       Timo Sirainen <tss@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 3:03 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
> Sorry for the delaying.
>
>> On Sat, Oct 10, 2009 at 2:32 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> >> It does seem like a maximum spin count should be put in there - and
>> >> maybe a timeout as well (since with FUSE etc it's possible to engineer
>> >> page faults that take arbitrarily long).
>> >> Also, it occurs to me that:
>> >
>> > makes sense.
>> > I like maximum spin rather than timeout.
>>
>> I'm worried about the scenario where process A sets its cmdline buffer
>> to point to a page which will take a _VERY_ long time to pagein (maybe
>> forever), and then process B goes to try to read its cmdline. What
>> happens now?
>
> Honestly, I don't worry about so much. if attacker want DoS attack, fork bomb is
> efficient than this way. then, attacker never use this.

Fork bombs and etc can be mitigated by resource limits; but if the
command line is placed on a page that will take a very long time to
fault, then that cannot be mitigated... But again, this DoS already
exists and isn't any easier with this patch, so I think it's a
separate issue.

>> Process A can arrange for this to happen by using a FUSE filesystem
>> that sits on a read forever. And since the first thing the admin's
>> likely to do to track down the problem is 'ps awux', this is liable to
>> be a rather nasty DoS...
>
> Probably, I haven't understand this paragraph. Why is this FUSE related issue?

Just an example of how one can create a page that will take a very
long time to fault in.
