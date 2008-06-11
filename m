Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbYFKN2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbYFKN2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbYFKN2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:28:13 -0400
Received: from sacred.ru ([62.205.161.221]:54611 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYFKN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:28:13 -0400
Message-ID: <484FD233.20602@openvz.org>
Date: Wed, 11 Jun 2008 17:25:07 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH] autofs4: fix 32-bit userspace vs 64-bit	kernel	communications
References: <484FA0B8.2000002@openvz.org>	 <1213187579.4994.25.camel@raven.themaw.net>  <484FC94E.1000209@openvz.org> <1213190100.4994.54.camel@raven.themaw.net>
In-Reply-To: <1213190100.4994.54.camel@raven.themaw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 11 Jun 2008 17:27:24 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the test_thread_flag(TIF_IA32) macro only return true for a 32-bit
> user-space process running within a 64-bit user space environment
> (perhaps I can do away with the check in the autofs daemon, perhaps it
> doesn't quite work correctly)?

Hm... If we fix it in the user level that would also be OK, I
suppose...

> Oh .. so maybe the answer to my question is yes?

It is - we check *only* for the process, that is to receive the 
packet.

> What about other arches offer 32-bit within a 64-bit environment (has
> this been the case on sparc64 at some point)?
> What about the compiler padding on these?

We have no technical ability to check this. First I wanted to
get your opinion about this particular fix for x86 machines.

As far as sparc(64) and other 32-to-64 are concerned - I can
start talking to their users/maintainers to check.

> Don't get me wrong, I'm not against fixing this, in fact I'd like to,
> but I'm concerned it may end up a bit of a can of worms.
