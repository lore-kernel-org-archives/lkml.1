Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYFKNoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYFKNoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYFKNoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:44:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42844 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbYFKNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:44:17 -0400
X-Sasl-enc: 1jyUwjgMwjoJelrGLstRZTsUcbTe4Y+s8hGZ37bpMQl8 1213191855
Subject: Re: [PATCH] autofs4: fix 32-bit userspace vs
	64-bit	kernel	communications
From: Ian Kent <raven@themaw.net>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
In-Reply-To: <484FD233.20602@openvz.org>
References: <484FA0B8.2000002@openvz.org>
	 <1213187579.4994.25.camel@raven.themaw.net>  <484FC94E.1000209@openvz.org>
	 <1213190100.4994.54.camel@raven.themaw.net>  <484FD233.20602@openvz.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 21:40:29 +0800
Message-Id: <1213191629.4994.61.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-11 at 17:25 +0400, Pavel Emelyanov wrote:
> > Does the test_thread_flag(TIF_IA32) macro only return true for a 32-bit
> > user-space process running within a 64-bit user space environment
> > (perhaps I can do away with the check in the autofs daemon, perhaps it
> > doesn't quite work correctly)?
> 
> Hm... If we fix it in the user level that would also be OK, I
> suppose...
> 
> > Oh .. so maybe the answer to my question is yes?
> 
> It is - we check *only* for the process, that is to receive the 
> packet.

Right, since the send is done in user context.

> 
> > What about other arches offer 32-bit within a 64-bit environment (has
> > this been the case on sparc64 at some point)?
> > What about the compiler padding on these?
> 
> We have no technical ability to check this. First I wanted to
> get your opinion about this particular fix for x86 machines.
> 
> As far as sparc(64) and other 32-to-64 are concerned - I can
> start talking to their users/maintainers to check.

I investigated only x86_64 and sparc64 but that was a quite a while ago
now. My sparc machine doesn't even have a Linux install atm.

If we can find a general and consistent solution I'm happy to remove the
check from the daemon and cope with the bit of pain it might cause.

> 
> > Don't get me wrong, I'm not against fixing this, in fact I'd like to,
> > but I'm concerned it may end up a bit of a can of worms.

