Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYHFOHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYHFOHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYHFOGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:06:47 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38923 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYHFOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:06:46 -0400
Message-ID: <44898.166.70.238.45.1218030342.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080806135410.GA39185@dspnet.fr.eu.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <Pine.LNX.4.64.0808051140150.6309@anakin>
    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
    <200808060133.10457.nickpiggin@yahoo.com.au>
    <87r6926dsr.fsf@basil.nowhere.org> <4899A313.7020708@tmr.com>
    <20080806135410.GA39185@dspnet.fr.eu.org>
Date: Wed, 6 Aug 2008 07:45:42 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Olivier Galibert" <galibert@pobox.com>,
       "Bill Davidsen" <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Aug 06, 2008 at 09:11:47AM -0400, Bill Davidsen wrote:
>> I would suggest that if it meets coding standards and doesn't break
>> anything else it could be included in -mm (assume there's no objection
>> there) and let people beat on it there, with the assumption that unless
>> problems are found it will be promoted.
>
> It's a little too early for that.  Right now it's at the phase "how to
> make it better integrate with the kernel", with the use of existing
> hooks, adding the needed hooks to be more complete, working as a
> module, etc.  When that is done then the philosophical aspects can
> come into play, but it's not there yet.
>
>   OG.
>

I have removed the hooks into the /arch/x86 sections and converted the
debugger to use kprobes and notify_die as Andi suggested.  It also builds
and loads as a module.

One serious point has to do with NMI handling on SMP since the notify_die
handlers use this priorty calling mechanism.  I am still testing on SMP
but it seems to work -- I just am a little uncomfortable with trusting an
interface (notify_die) that can let someone come in and hook the NMI
handlers when I MUST BE ABLE TO NMI AND HALT non-focus processors first.

I am adding a special NMI state to the chain notifier to handle this case
where IT MUST BE CALLED FIRST and IT MUST BE THE ONLY EVENT CALLED.  I
used the DIE_KERNELDEBUG to hook the keyboard handler in
drivers/char/keyboard.c so we have the general hook into kprobes to handle
enter debugger events.

Jeff

