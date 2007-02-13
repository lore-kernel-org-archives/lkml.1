Return-Path: <linux-kernel-owner+w=401wt.eu-S1030587AbXBMAaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587AbXBMAaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030590AbXBMAaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:30:14 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:41775 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030587AbXBMAaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:30:12 -0500
Message-ID: <45D1068D.4060906@vilain.net>
Date: Tue, 13 Feb 2007 13:30:05 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       containers@lists.osdl.org, winget@google.com, rohitseth@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>	 <45D0EC68.9090009@vilain.net> <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
In-Reply-To: <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>> I know I'm a bit out of touch, but AIUI the NSProxy *is* the container.
>> We decided a long time ago that a container was basically just a set of
>> namespaces, which includes all of the subsystems you mention.
>>     
> You may have done that, but the CKRM/ResGroups independently decided a
> long time ago that the fundamental unit was the resource class, and
> the OpenVZ folks decided that the fundamental unit was the
> BeanCounter, and the CPUSet folks decided that the fundamental unit
> was the CPUSet, etc ... :-)
>   

There was a consensus that emerged that resulted in the nsproxy being
included in the kernel.  That is why I used "we".  What was included
varies greatly from the patch I put forward, as I mentioned.

You missed the point of what I was trying to say.  Let me try again.

Originally I too thought that in order to begin on the path of
virtualisation merging we would just make a simple
container/vserver/whatever structure and hang everything off that.

I'll now say the same thing that was said before of my patch, that I
don't think that adding the containers structure inside the kernel adds
anything interesting or useful.  In fact, I'd go further to say that
very thing you think is a useful abstraction is locking yourself into
inflexibility.  This is what Eric recognised early on and eventually
brought me around to the idea of too.

So, we have the current implementation - individual subsystems are
virtualised, and it is the subsystems that you can see and work with. 
You can group together your virtualisation decisions and call that a
container, great.

Ask yourself this - what do you need the container structure for so
badly, that virtualising the individual resources does not provide for? 
You don't need it to copy the namespaces of another process ("enter")
and you don't need it for checkpoint/migration.  What does it mean to
make a new container?  You're making a "nothing" namespace for some
as-yet-unspecified grouping of tasks.  That's a great idea for a set of
tightly integrated userland utilities to simplify the presentation to
the admin, but I don't see why you need to enshrine this in the kernel. 
Certainly not for any of the other patches in your set as far as I can see.

> But there's a lot of common ground between these different approaches,
> and potential for synergy, so the point of this patch set is to
> provide a unification point for all of them, and a stepping stone for
> other new resource controllers and process control modules.
>   

That precisely echos my sentiment on my submissions of some 12 months ago.

Sam.
