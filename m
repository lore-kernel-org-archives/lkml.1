Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZCaGiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZCaGiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZCaGih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:38:37 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:47377 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZCaGih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:38:37 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18897.46177.528910.51044@cargo.ozlabs.ibm.com>
References: <20090330170701.856843742@chello.nl>
	 <20090330171024.254266860@chello.nl>
	 <18897.46177.528910.51044@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 08:39:12 +0200
Message-Id: <1238481552.28248.1384.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 17:12 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> >  				include_tid    :  1, /* include the tid       */
> >  				mmap           :  1, /* include mmap data     */
> >  				munmap         :  1, /* include munmap data   */
> > +				callchain      :  1, /* add callchain data    */
> 
> Interesting, I would have put callchain (and include_tid, also) in
> hw_event.record_type rather than as individual 1-bit fields.  The
> present arrangement where some selection of what goes into the ring
> buffer is in record_type and some is in individual bits seems a bit
> awkward.  Plus, with the current arrangement I can't get both the IP
> and the values of the other group members, which I might reasonable
> want.
> 
> I think either we make record_type bit-significant, or we define
> individual bits in hw_event for recording the IP and other group
> members.
> 
> There are a couple of other things I want to be able to record on an
> event - we have registers on powerpc that give information about the
> event that caused the interrupt, and it would be nice to be able to
> record them.  (These registers include instruction and data addresses
> associated with the event; the instruction address can be further on
> from where the interrupt was taken because of out-of-order instruction
> execution and because interrupts might be hard-disabled at the point
> where the interrupt becomes pending.)
> 
> Those registers would need bits in record_type or in the hw_event to
> indicate that we want them recorded.

Sure, I'm fine with moving them to record_type and making that a bit
field. I've also considered merging the group and 'simple' output to
enable what you say.



