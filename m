Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZETQQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZETQQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZETQQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:16:14 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:37471 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZETQQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:16:13 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Corey Minyard <minyard@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dann frazier <dannf@hp.com>
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
	<20090516170959.8057c9e4.akpm@linux-foundation.org>
	<877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
	<87iqjxzjz4.fsf@tac.ki.iif.hu> <4A1326C5.4010308@acm.org>
Date: Wed, 20 May 2009 18:15:43 +0200
In-Reply-To: <4A1326C5.4010308@acm.org> (Corey Minyard's message of "Tue, 19
	May 2009 16:38:13 -0500")
Message-ID: <87ljoriwcw.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard <minyard@acm.org> writes:

> I know what is happening now.  Can you try the attached patch?  I'm
> disabling the requeue and discarding the message when an IPMB message
> is received before everything is initialized.  If you don't, the code
> will not deliver any messages because something is already in the
> queue.

Yep, that fixed it, modprobe runs through now!

> Ferenc Wagner wrote:
>
>> My concern is that it does something too often, not letting the CPU
>> enter deep sleep states, perhaps.  Or is that also an artifact of
>> debugging?
>
> No, it's an artifact of a lousy hardware interface.  Very few IPMI
> interfaces support interrupts, so they have to be polled :(.

I'd say this isn't an artifact but the sad truth itself.  Just out of
interest, how often does the driver wake up to check the inteface?
-- 
Thanks,
Feri.
