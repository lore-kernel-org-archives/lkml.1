Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbYCFQPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbYCFQPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbYCFQPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:15:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYCFQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:15:00 -0500
Date: Thu, 6 Mar 2008 17:14:59 +0100
From: Jan Kara <jack@suse.cz>
To: Nix <nix@esperi.org.uk>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Message-ID: <20080306161459.GB3702@atrey.karlin.mff.cuni.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix> <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oda6p9st.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 24 Feb 2008, Peter Osterlund told this:
> 
> > Nix <nix@esperi.org.uk> writes:
> >> But while I'd normally blame pktcdvd there's only one pktcdvd function
> >> in these tracebacks (pkt_open) and it's not got a significant stack
> >> footprint.
> >
> > Did you verify that with "make checkstack" or just by looking at the
> > source code? On my system, pkt_open() consumes 584 bytes because the
> > compiler decides to inline lots of functions that would not normally
> > be part of long call chains. The following patch fixes that problem on
> > my system.
> 
> I just looked at the source; I forgot `make checkstack' existed.
> 
> On this system:
> 
> 0xc0263e0f pkt_open [vmlinux]:                          556
> 
> which is nearly as bad.
> 
> (As an aside, I'm surprised I didn't oops when packet-writing as well:
> 
> 0xc021270d udf_process_sequence [vmlinux]:              692
> 0xc020f43d udf_add_entry [vmlinux]:                     628
> 
> owch. I guess that's called via a shorter call chain...)
> 
> 
> I'll try the patch after this series of backups is done :)
  If you are interested, linux-next or -mm tree should contain a patch now
that fixes the problem...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
