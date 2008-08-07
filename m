Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYHGNHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYHGNHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYHGNGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:06:54 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:47266 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYHGNGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:06:53 -0400
Message-ID: <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080806185719.GE24801@one.firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <Pine.LNX.4.64.0808051140150.6309@anakin>
    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
    <200808060133.10457.nickpiggin@yahoo.com.au>
    <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com>
    <20080806185719.GE24801@one.firstfloor.org>
Date: Thu, 7 Aug 2008 06:45:34 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Jason Wessel" <jason.wessel@windriver.com>,
       "Andi Kleen" <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



UPDATE:

As per everyone's recommendations, the debugger has been fully
module-ized, and I have run checkpatch.pl and am cleaning up the slew of
messages checkpatch spits out of its tailpipe.

It would be nice if checkpatch also could FIX those areas it complains about.

I tested kprobes with NMI cross processor calls on SMP and I am unable
to break it, and the module loads and unloads very well.  There is a need
for early initialization of the debugger if someone wants to debug kernel
startup and I am including support for this with another.config option,
but I am concerned about the reliance of kprobes on rcu and if this will
break early init of the debugger.   The code looks ok, but another set of
eyes
would be helpful when I post the next patch series.

I will generate another patch series after I finished cleaning up the
checkpatch.pl report.  I am still going through it.

Also, whoever wrote "/Documentation/volatiles_are_evil" must not have
worked with the busted-ass GNU compiler that optimizes away global
variables and busts SMP dependent code.  I am not going to remove the
volatile declarations needed for SMP coordination in the debugger since
the code breaks when removed.  GCC will cause massive breakage of SMP code
if you do not declare certain variables as volatile.

Whoever wrote that section doesn't understand low level SMP coding for
operating systems design and aparently has not sent over a week running
down an SMP bug only to discover it was caused by the busted-ass GCC
compiler arbitrarily deciding to optimize away a low level flag used to
signal between processors -- I have spent the time running down Stallman's
bugs.

That text should be removed from the kernel or qualified that its
advertising for GCC's malfunctioning optimization code.

Jeff



