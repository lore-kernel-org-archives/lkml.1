Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0BDVOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:14:41 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:32927 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab0BDVOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:14:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZApYqKSQPGr33be3msOJrDbDfYksPgemoqKhp2hRoFk8sbY+8JQlVLum0jODdnvDkp
         XFStC2BIb/jfXnWf6m7Hya54rxf7oGHufz2wgiIDBWoDKezVvYaoC7yg0nHLwzuH/Nj/
         3+/cfFtTk7mQOwkfPPxQiz6WZRH13WDzcU+10=
MIME-Version: 1.0
In-Reply-To: <20100204204655.GA19050@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
	 <20100202154450.GC27314@elte.hu>
	 <21d7e9971002041239i5e842698pd8a775f833fc5d51@mail.gmail.com>
	 <20100204204655.GA19050@elte.hu>
Date: Fri, 5 Feb 2010 07:14:38 +1000
Message-ID: <21d7e9971002041314yf8c55p4a7cb638efa0d24a@mail.gmail.com>
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off 
	switch out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 6:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Airlie <airlied@gmail.com> wrote:
>
>> On Wed, Feb 3, 2010 at 1:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Dave Airlie <airlied@linux.ie> wrote:
>> >
>> >> > It's the moving of radeom KMS out of staging after -rc6 that causes it,
>> >> > because it brought it into the scope of my testing:
>> >> >
>> >> > ?f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
>> >> >
>> >> > So at least on this box it's clearly not ready for mainline enablement
>> >> > yet. I've attached the revert patch further below.
>> >>
>> >> Its not enabled by default so reverting this doesn't make much sense.
>> >
>> > I boot allyesconfig kernels regularly, which testing method works fine
>> > with another 2000+ upstream drivers. (including the dozens of drivers
>> > which match to active hardware components on that box)
>>
>> Okay this was something I wondered about, since these are *not*
>> allyesconfig .configs, I've generated some and CONFIG_FB_RADEON is always
>> on here, and you seem to not have that enabled (not that enabling it is a
>> good idea it is in fact a really bad idea).
>
> These were random configs - the size doesnt match an allyesconfig, those are
> way bigger. My above comment related to the first crash, and to my argument
> that all other drivers are fine during bootup - and there's a lot of them.
>
>> So do you have something you are running after allyesconfig to fix things?
>> or have you just got a config that is close enough to allyesconfig.
>>
>> I'm building kernels with your .config now and boot testing them on the
>> full range of hardware I have/
>
> Thanks. Is there something i can enable to get a better log for you to find
> out where (and why) it's hanging? It's still early during bootup so the box
> is not particularly debuggable - so i'm not sure i can get a task list dump,
> etc., unfortunately.
>

Do you have NMI watchdog enabled? (does it work that early)

a backtrace of where it hangs would be nice,

Also a dmesg from booting with drm.debug=15 might help narrow it down
also.

Dave.

>        Ingo
>
