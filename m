Return-Path: <linux-kernel-owner+w=401wt.eu-S965452AbXBMBNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbXBMBNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965453AbXBMBNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:13:15 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:36046 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965452AbXBMBNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:13:14 -0500
Message-ID: <45D110A3.1010502@vilain.net>
Date: Tue, 13 Feb 2007 14:13:07 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com
Subject: Re: [ckrm-tech] [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>	 <45D0EC68.9090009@vilain.net>	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>	 <45D1068D.4060906@vilain.net> <6599ad830702121642w80c53ddud3c77c13af99d2b7@mail.gmail.com>
In-Reply-To: <6599ad830702121642w80c53ddud3c77c13af99d2b7@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>> Ask yourself this - what do you need the container structure for so
>> badly, that virtualising the individual resources does not provide for?
>>     
> Primarily, that otherwise every module that wants to affect/monitor
> behaviour of a group of associated processes has to implement its own
> process grouping abstraction.
>   

Not every module, you just make them on sensible, planned groupings. 
The danger is that the "container" group becomes a fallback grouping for
things when people can't be bothered thinking about it properly, and
everything including the kitchen sink gets thrown in.  Then later you
find a real use case where you don't want them together, but it's too
late because it's already a part of the official API.

> As an example, the CPU accounting patch that in included in my patch
> set as an illustration of a simple resource monitoring module is just
> 250 lines, almost entirely in one file; if it also had to handle
> associating tasks together into groups and presenting a filesystem
> interface to the user it would be far larger and would have a much
> bigger footprint on the kernel.
>   

It's also less flexible.  What if I want to do CPU accounting on some
other boundaries than the "virtual server" a process is a part of?

> From the point of view of the virtual server containers, the advantage
> is that you're integrated with a standard filesystem interface for
> determining group membership. It does become simpler to combine
> virtual servers and resource controllers, although I grant you that
> you could juggle that from userspace without the additional kernel
> support.
>   

I'm not disagreeing it's a pragmatic shortcut that has been successful
for a number of projects including vserver which I use every day.  But
it reduces "synergy" by excluding the people working with virtualisation
in ways that don't fit its model.

Yes, there should be a similarity in the way that you manage namespaces
and it should be easy to develop new namespaces without constantly
re-inventing the wheel.  But why does that imply making binding
decisions about the nature of how you can virtualise?  IMHO those
decisions should be made on a per-subsystem basis.

Sam.
