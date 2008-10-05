Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYJEWpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYJEWpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYJEWpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:45:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36041 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbYJEWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:45:43 -0400
Message-ID: <48E94390.2080209@firstfloor.org>
Date: Mon, 06 Oct 2008 00:45:36 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional hotplug
 CPUs to be set at compile time
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org> <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo> <20081005152025.GA27066@elte.hu> <alpine.LFD.2.00.0810051732380.3398@apollo> <48E9261A.9060501@firstfloor.org> <alpine.LFD.2.00.0810052252520.3398@apollo>
In-Reply-To: <alpine.LFD.2.00.0810052252520.3398@apollo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Your proposed solution is:
> 
>      exporting additional_cpus  and change the check to:
> 
>      if ((num_possible_cpus() - additional_cpus) == 1 ...
> 
> This is simply stupid. We have the information already in
> num_present_cpus() and that's the correct check in the alternatives
> code.

Yes that is correct.  Using present_cpus is cleaner than
my version patch  (although it wasn't quite at a "mess" level imho).
No argument on that. But that  is not what my emails were about.

They were about the removal of the additional_cpus=... parameter
which was unfortunately done too.

additional_cpus is used for more than just alternatives processing.
It is also used to size the possible map and declare additional
hotplug CPUs.

Please read the Documentation cpu-hotplug-spec I referred to earlier
for background. Or Documentation/cpu-hotplug.txt which has it too.

additional_cpus is used to tell Linux that there are more (or less)
CPUs hotpluggable than the BIOS declares at boot time. This is needed
because the way the BIOS is declaring it is a Linux extension, not standard.
But even if it was standard it would be good policy to be able
to override it because as we all know BIOS can be wrong, as in
declare far too many.

But now that option is gone so this needed override isn't there

> additional_cpus is useless ballast.

For the alternatives heuristics yes. For hotplug no.

Only when you assume that all hotpluggable BIOS implement
the "cpu-hotplug-spec" Linux extension and always declare
hotplug correctly. That's quite dubious.

> 	tglx - who refrains from adding a nasty insulting comment

Feel free to speak your mind if the facts are correct.

-Andi

