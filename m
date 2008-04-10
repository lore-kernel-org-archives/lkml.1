Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYDJRYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYDJRYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYDJRY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:24:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54198 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbYDJRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:24:28 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5271"; a="2345779"
Message-ID: <47FE4D4A.70109@qualcomm.com>
Date: Thu, 10 Apr 2008 10:24:26 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com>	<20080312183059.6716d630.pj@sgi.com>	<47D87BE5.4010702@qualcomm.com> <20080313021253.a99fc8d1.pj@sgi.com>
In-Reply-To: <20080313021253.a99fc8d1.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for disappearing on you guys. I'm working on releasing the user-space 
framework and engine that uses cpu isolation for hard-RT. Once that's done I'm 
going to resurrect these efforts. In the mean time let me reply to your last 
comments.

Paul Jackson wrote:
>> How about we add support for sym links to the cgroup fs ?
> 
> Still pollutes the primary cpuset name space ... you have all
> the directories X, X/A, and X/B as well as the symlinks A and B.
> 
> Symlinks allow for one path that needs to be 'aliased' to another,
> but they are a one-way map; without an exhaustive search of the
> potential namespace, one can't invert them, or determine if they
> can't be inverted.
> 
> Tools have to constantly make heuristic decisions whether to
> default to dereferencing the symlink, or not, and often have to
> provide alternatives for the non-default choice.
> 
> They are a pain in the backside even if designed in and expected
> up front.
> 
> If added as critical structure after the fact, something breaks,
> pretty much for sure.
> 
> For one minor example, code I've probably buried someplace that
> does "find /dev/cpuset -type d" to find all cpusets would break.
> 
> Or the one-line /sbin/cpuset_release_agent script:
> 	rmdir /dev/cpuset/$1
> is broken -- fails to clean-up associated symlinks, and can't
> avoid race conditions if it tries to add code to do that.
> 
>> Crazy idea.
> 
> Agreed ;)

Got it. Symlinks are out :)

Max


