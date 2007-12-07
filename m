Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXLGStx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXLGStx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXLGStn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:49:43 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2739 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbXLGStm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:49:42 -0500
Date: Fri, 7 Dec 2007 13:48:10 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@redhat.com>, Ben Woodard <woodard@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071207184810.GB18485@hmsreliant.think-freely.org>
References: <474F7177.7050306@redhat.com> <20071130144250.GC23810@redhat.com> <20071130145131.GB5822@hmsendeavour.rdu.redhat.com> <20071206213951.GB28898@hmsreliant.think-freely.org> <20071206221143.GC2863@redhat.com> <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com> <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com> <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com> <20071207142144.GA10389@hmsendeavour.rdu.redhat.com> <m1y7c6qrlh.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7c6qrlh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 11:36:58AM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@redhat.com> writes:
> 
> > this seems reasonable, I can reroll the patch for this.  As I think about it I'm
> > also going to update the patch to make this check occur for any pci class 0600
> > device from vendor AMD, since its possible that more than just nvidia chipsets
> > can be affected.
> >
> > I'll repost as soon as I've tested, thanks!
> 
> Thanks.
> 
> Neil in your testing please confirm the preconditions for setting 
> the Apic Extended Broadcast flag (bit 17) are present.
> 
The systems that I have here do _not_ in fact have that precondition, but the
systems from Ben, who originoally reported the problem do have that
precondition, and he has reported that this fixes the hang in the kdump boot.

> If that is the case it makes sense to always set that bit on conforming
> systems but we will also want to print a message noting that the
> BIOS has a bug, and we are working around it.
> 
I've got two printk's in this patch, one that indicates that Extended APIC ID's
are in use, and a second that indicates that there is a mismatch between the use
of extended APIC ids (bit 18) and the lack of an extended APIC id dest mask for
interrupt packets (bit 17).  Not sure if that meets you're requirements, but I
think its sufficient.  If you disagree, let me know and we can enhance them.

Thanks
Neil

