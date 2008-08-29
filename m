Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYH2RDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYH2RDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbYH2RDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:03:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYH2RDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:03:00 -0400
Date: Fri, 29 Aug 2008 13:02:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Subject: Re: [ RT PATCH] seqlock: serialize against writers
In-Reply-To: <20080829095729.0966d38e@extreme>
Message-ID: <alpine.DEB.1.10.0808291300580.17917@gandalf.stny.rr.com>
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <20080829095729.0966d38e@extreme>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


/me adds "RT" to subject.

On Fri, 29 Aug 2008, Stephen Hemminger wrote:
> 
> I have mixed feelings about this. The point of this primitive was for
> cases where write contention was rare and writers only did small updates.
> So what you did was fix the primitive for cases where it is being misused.
> Do you have a real example where this is a problem? If so then the
> user of seqlock should be fixed, rather than fixing seqlock.
> 


I think there's some confusion here, because of the changes to raw. The 
raw_seqlock_t and mainline seqlock_t has no issue, and should not be 
touched.

What Gregory is solving is an issue in -rt where we let write seqlocks be 
preempted.  Thus this causes issues with determinism. This is a special 
case for -rt, and -rt only. It should not affect mainline in anyway.

Sorry for the noise.

-- Steve

