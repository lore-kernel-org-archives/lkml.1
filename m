Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZD2G4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZD2G4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZD2G4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:56:34 -0400
Received: from fornax.pixelized.ch ([88.198.8.169]:54469 "EHLO
	fornax.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZD2G4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:56:33 -0400
Message-ID: <49F7F9FB.7030300@cateee.net>
Date: Wed, 29 Apr 2009 08:55:55 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, david@lang.hm
Subject: Re: kms in defconfig
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>	<20090427083935.GA20941@elte.hu>	<21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>	<49F65FA2.4010603@kernel.org>	<alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>	<alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm>	<alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>	<alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm>	<alpine.LFD.2.00.0904281043420.22156@localhost.localdomain> <20090428234300.4a49d22f@schatten>
In-Reply-To: <20090428234300.4a49d22f@schatten>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Mickler wrote:
> On Tue, 28 Apr 2009 10:50:14 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Tue, 28 Apr 2009, david@lang.hm wrote:
> 
>>> I've seen people talk about creating such tools, but the responses
>>> that I've seen have tended to discourage them.
>> I suspect that they'd generally end up handling the easy cases, and
>> seldom anything more. At which point they're not all that useful.
>>
>> 		Linus
> 
> perhaps there needs to be an infrastructure where each
> kconfig-entry-causer can also provide userlevel code to help with that
> entry?
> 
> i could imagine a kconfig knob to specify an optional
> per-kconfig-userspace-helperscript which calculates a new "suggested
> value" at configure time. 
> this "suggested value" is displayed next to the default value 
> or is then already incorporated in the default value. 
> 
> each maintainer of each kconfig entry 
> a) decides if it is possible to supply such a script 
> b) if it would be useful
> c) suplies and maintains his (focused on only one kconfig entry) script
> c) if the script is 100% fool-proof he can say so in the description of
> the kconfig-entry or just skip the user or notify the user of the
> result. 
> d) maybe dosn't provide an userspace helper
> 
> this spreads the burden of the complex detection-code and hopefully
> eases configuration for everyone where possible.
> 
> what do others think?

Not feasible!  Look at the default values or at the help text of options:
you see a lot of old and obsolete text.
Take e.g.: CONFIG_SMP, the intel AGP/DRI, or in general: help texts describe
usually only the first hardwares supported.
I think such scripts could not do better: soon will be obsolete.

It is also not difficult to do a central script.
I regularly build a map from modules, mosts buses, etc to the kernel config
(see lkddb.list in http://cateee.net/sources/lkddb ). With explicit
coding policy and few patches in kernel it would be easier to generate, but...

the problem is in Kconfig: actual interface is ugly:
it is difficult to know how to add support for an hardware, or to
remove a driver (because of linear dependencies and need to fullfil
the dependencies before to enable/disable drivers), and dependencies are
often not obvious.
Take a default kernel from your distribution and try to remove most of
non-needed hardware, using existing interfaces (ok, the Linus' sed method
simplify the problem, but try to do manually with menuconfig.

After we replace the build system we could try to develop a right
"autoconfiguration", which is IMHO a trivial task.
But the new build system need to solve dependencies (like modern
package managers). Actual system checks only dependencies, but user
must know and set it before to configure a specific item.

But creating a new configuration system, with dependency solver, is very
complex: the kernel has an interesting third state: "m". So we should handle
3 cases: n/m/y, and some policies:
- prefer m / prefer y
- default values
- on usefull (e.g. filesystems) "non hardware": n / m / y
  (but not on virtualization, debug)
- ...

So the old problem: automation and complexity: the solver must do the right thing,
but probably there is no "right thing" for everybody (or for most people), so we
cannot automatize it.

ciao
	cate
