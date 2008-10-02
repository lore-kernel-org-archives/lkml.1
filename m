Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYJBTij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYJBTij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYJBTia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:38:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44277 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYJBTia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:38:30 -0400
Date: Thu, 2 Oct 2008 21:44:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs to be set at compile time
Message-ID: <20081002194409.GB8318@one.firstfloor.org>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002152521.16c4835b@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 03:25:21PM -0400, Chuck Ebbert wrote:
> On Thu, 02 Oct 2008 11:12:51 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Chuck Ebbert <cebbert@redhat.com> writes:
> > 
> > > The default number of additional CPU IDs for hotplugging is determined
> > > by asking ACPI or mptables how many "disabled" CPUs there are in the
> > > system, but many systems get this wrong so that e.g. a uniprocessor
> > > machine gets an extra CPU allocated and never switches to single CPU
> > > mode.

What do you mean with single cpu mode?

e.g. the lock prefix rewriting is only determined by online CPUs,
not possible CPUs. And this only affects the possible ones.

I'm not aware of any other special mode with num_possible_cpus() == 1,
only for num_online_cpus() == 1


> > 
> > You can set this with additional_cpus=... at boot time.
> > I don't think each runtime option needs a CONFIG option too.
> > 
> 
> Well not all of them, but this one is a good candidate.  Either that or
> we should just change the default to zero.

An extra possible CPU is not that costly.  A 64bit kernel with my old
defconfig has about 40k of per CPU data which would be duplicated.
And having real hotplug always require that option would be nasty.

What you could probably do if you really worry about the 40k is to do
some special casing, as if you know there is only a single socket 
(can be determined from the APIC IDs in the ACPI tables) and the CPU
is only single core then don't allocate it.
For HT it is harder, there is no real way to distingush P4 Celerons
with HT fused off. 

But frankly having such special code just for 40k savings (or 
likely much less on 32bit) seems a little overkill to me.

-Andi
-- 
ak@linux.intel.com
