Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYKZJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYKZJXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYKZJXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:23:05 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:58884 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYKZJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HM8KQNpqEJ+Ms0NluBgy9f6dZ+zKJzTEp4zCLh5efcqbcrlb7Wm5TcqszMIff+hCUL
         4bLVYCWfmNKj6epM5LgK2EV+A3Pyge3WtUsge29/ORI1UNP8L6IRXhZA5MmVqsrGvfha
         /nv7+lyPweRiPXq6Q39Od/PsxMXe/APsK7zjs=
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081126010503.747871b3.akpm@linux-foundation.org>
References: <20081126051622.134970943@goodmis.org>
	 <20081126051709.774546196@goodmis.org>
	 <20081125213546.ff4eddf4.akpm@linux-foundation.org>
	 <1227682349.5511.47.camel@brick>
	 <20081126000430.5c19e189.akpm@linux-foundation.org>
	 <1227688024.5511.56.camel@brick>
	 <20081126003553.12d38150.akpm@linux-foundation.org>
	 <1227689088.5511.62.camel@brick>
	 <20081126010503.747871b3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 01:22:55 -0800
Message-Id: <1227691375.5511.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 01:05 -0800, Andrew Morton wrote:
> > 
> > Do you want to carry the patches to move to the new helpers until they
> > hit mainline, or would you rather I waited until they can go through
> > maintainer trees?
> 
> I don't know what that means, really.
> 
> > I've got the pile ready removing all of the get/put_{endian} and moving
> > to the load/store API.  Not much left after that to just remove the
> > magical sizeof versions too.  Just let me know what timing you'd prefer.
> 
> I don't understand the dependencies and relationships here.

The pile I refer to depends on the full set of patches in -mm which
includes (I can give all the patch names if you want):

1) byteorder patches moving all remaining arches to use
include/linux/byteorder.h

2) unaligned access patches consolidating arches in
asm-generic/unaligned.h with no changes

3) move the memset-using arches and ARM to the asm-generic version
by moving __packed onto the struct rather than the struct members

4) introduce the load/store_{endian} API

Timing:

1) - 2) I hope all gets into mainline in 2.6.29. 

3) I believe could go in 2.6.29, and I'm pretty confident it is OK after
talking to some compiler folks.

4) can go in with 3)

My pile is just removing users of get_unaligned/put_unaligned/{endian}_to_cpup
and using the new typesafe versions.  At the end of the series we remove the old API.

> 
> If you have a bunch of patches which are applicable to current mainline
> then just spray 'em out with suitable cc's and we'll see which bits
> stick where.  Or is it more complicated than that?

See above, not suitable for mainline.

> 
> > Also, all of this ends up being so intertwined in the aligned/unaligned
> > cases that I'd like to move most of Documentation/unaligned_memory_access.txt
> > into a new alignment_and_byteorder.txt to cover all of these new helpers.
> > 
> > I started most of a byteorder document, but constantly referring to the other
> > file made it a bit tiresome, would you mind a consolidated document?
> 
> Whatever you think is best.  Propose something...

Thinking some more, I'll just dump the new endian docs into unaligned_access.txt
and that at least gets the documentation out there.  Later on it be renamed to
something more reflective of its contents.

Harvey

