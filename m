Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYA3VD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYA3VD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYA3VDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:03:50 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21542 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYA3VDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:03:49 -0500
Message-ID: <47A0E632.8010804@msgid.tls.msk.ru>
Date: Thu, 31 Jan 2008 00:03:46 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
References: <47A0CD90.5080208@msgid.tls.msk.ru> <200801302112.41446.bonbons@linux-vserver.org>
In-Reply-To: <200801302112.41446.bonbons@linux-vserver.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont wrote:
> On Wednesday 30 January 2008 20:18:40 you wrote:
>> I'm trying to "glue" hibernation and UPS control
>> together, and have a question.
>>
>> When the system power comes off an UPS (Uninterruptable
>> Power Supply I mean), it's probably a good idea to turn
>> the UPS off when shutting the system down or hibernating.
>
> This depends on how you can turn the UPS back on...

Most UPSes has an option to turn themselves on when the
power returns (except of very dumb ones).

> If pushing the button manually is not an issue or the UPS
> can still be controlled remotely (e.g. via network) when
> being off it doesn't matter.

It does not matter really.

[]
>> returns.  Now, when we shutting down a system, we
>> need to turn the UPS *before* powering down the
>> system but *after* the shutdown procedure has been
>> completed.  This is done by replacing poweroff with
>> halt, and ordering the UPS to turn itself off after
>> a small delay (needed for the poweroff command to
>> complete) - this way, system will be on but in a
>> safe-to-powercut mode, and in order to turn it
>> back on only the UPS has to be turned on.
>
> All systems I've seen that provide such an option in the BIOS
> list three possible actions on power-back:
> - remain off
> - go back to previous state
> - boot

Or sometimes a subset of the 3 - like "always off or return to
previous state".  But this does not matter again - I'm not
asking about how to control the power-on feature, or how to
control a particular UPS, -- instead, I'm asking how to hook
up something into the hibernate path, to the very end of it,
to do whatever is needed, and/or how to control whether after
the hibernate is complete the kernel should turn the system
off or not.

> In your case it's possibly easier to choose the option to
> always boot when power comes back.

Whatever works and is most suitable given the particular
situation.  It doesn't really matter here.

[]
> Can you configure your UPS to poweroff when load on its output
> drops below a given threshold? (I know that such a feature
> exists on master-slave power outlets where all slave outlets
> are powered only when the master outlet has a sufficient load)

Certain models can be configured this way.  But the question
stands still, because many models can't be programmed this way.

What's needed is to run something at the end of hibernate
process, nothing more nothing less.

> Another path may be to dig into hibernate via kexec:
>   http://kerneltrap.org/node/11756

Well.. that might work after all.  It doesn't work
with vanilla kernel, does it?  I mean, I can get
*my* system to work as I like it to work, but it
can't work on another Linux system...

>> P.S.  Surprisingly, there's NO software that works
>> with UPSes and implements even the basic shutdown
>> process completely (not even mentioning hibernation).
>> Most common is just to turn the system off without
>> touching the UPS.  Yes it will work (till the UPS
>> will run out of battery), but how about servers which
>> should be up-n-running, ie. which should restart
>> automatically?..  Oh well.
>
> Can't the UPS software trigger scripts or be controlled
> using scripts?

In some cases it can, but usually in a very limited way.
It's just like no one wrote good software about this
topic... ;)  Or good scripts, for that matter.  That's
exactly what I'm trying to do, and certain questions
(like this one) pops up.

Thanks.

/mjt
