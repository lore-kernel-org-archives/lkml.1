Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYJBUK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYJBUK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 16:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYJBUKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:10:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54378 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYJBUKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:10:14 -0400
Date: Thu, 2 Oct 2008 16:09:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs
 to be set at compile time
Message-ID: <20081002160907.68d79e0b@redhat.com>
In-Reply-To: <20081002194409.GB8318@one.firstfloor.org>
References: <20081001191945.4182d0be@redhat.com>
	<87bpy3pdgs.fsf@basil.nowhere.org>
	<20081002152521.16c4835b@redhat.com>
	<20081002194409.GB8318@one.firstfloor.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 21:44:09 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Oct 02, 2008 at 03:25:21PM -0400, Chuck Ebbert wrote:
> > On Thu, 02 Oct 2008 11:12:51 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Chuck Ebbert <cebbert@redhat.com> writes:
> > > 
> > > > The default number of additional CPU IDs for hotplugging is determined
> > > > by asking ACPI or mptables how many "disabled" CPUs there are in the
> > > > system, but many systems get this wrong so that e.g. a uniprocessor
> > > > machine gets an extra CPU allocated and never switches to single CPU
> > > > mode.
> 
> What do you mean with single cpu mode?
> 
> e.g. the lock prefix rewriting is only determined by online CPUs,
> not possible CPUs. And this only affects the possible ones.
> 


The prefix rewriting doesn't happen unless I boot with additional_cpus=0,
maxcpus=1, or with this patch applied and the config option set. I think
the rules for when/if the rewriting happens changed a while ago to avoid
multiple switches and now it's not happening at all on this machine by
default.

Oh, and with NR_CPUS=512 I am seeing 1.6MB per-cpu data (I'll have to
check that, but I remember being surprised at how big the number was.)
