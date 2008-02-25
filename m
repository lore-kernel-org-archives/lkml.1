Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYBYUd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYBYUd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYBYUdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:33:19 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112AbYBYUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:33:18 -0500
Date: Mon, 25 Feb 2008 12:30:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nix <nix@esperi.org.uk>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Jan Kara <jack@ucw.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow:
 ide-cd related? dm-related?
Message-Id: <20080225123041.401da103.akpm@linux-foundation.org>
In-Reply-To: <87oda6p9st.fsf@hades.wkstn.nix>
References: <87wsovkth5.fsf@hades.wkstn.nix>
	<87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com>
	<87oda6p9st.fsf@hades.wkstn.nix>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 17:02:26 +0000 Nix <nix@esperi.org.uk> wrote:

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

udf_process_sequence() seems to be another victim of gcc inlining.

udf_add_entry() defines a couple of 256-byte local arrays.
