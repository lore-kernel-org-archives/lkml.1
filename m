Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbYGORIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbYGORIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYGORIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:08:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256AbYGORIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:08:37 -0400
Date: Tue, 15 Jul 2008 10:07:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <200807151848.26026.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0807150954320.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org> <alpine.LFD.1.10.0807150931010.3017@woody.linux-foundation.org> <200807151848.26026.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Frans Pop wrote:
> 
> Of course, but the main reason I replied in the first place was because 
> your "there are no real problems" attitude in this discussion was 
> annoying me.

I really don't think there are any real problems.

The problems are all due to inertia - people (and scripts) are used to one 
way of doing things. Those aren't really technical issues, and more 
importantly, they are not issues that _can_ be solved any other way than 
just doing it, and fixing the fallout.

Trying to be "proactive" doesn't work. Waiting for people (and scripts) to 
get used to a new model before merging it also doesn't work. And 
complaining about a change that pretty obviously is needed also doesn't 
work.

So let's just do it. And then, when specific scripts are encountered, fix 
them. And yes, fixing the scripts may _well_ imply adding more support for 
it in the kernel. It could be either in build and installation scripts, or 
in udev infrastructure, or in request_firmware() capability itself.

For example, some people hate udev, and they may have some really good 
reason why they really don't want to rely on that in their setup. So maybe 
we should teach request_firmware() to try to look up (binary) firmware 
files directly from the filesystem before it does a udev callback (in 
fact, maybe it even already does - I really didn't check very closely).

None of these are "problems". 

But people who don't even want to look for solutions - _that_ is a 
problem.

			Linus
