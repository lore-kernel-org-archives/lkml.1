Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYHKPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYHKPyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYHKPyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:54:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYHKPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:54:34 -0400
Date: Mon, 11 Aug 2008 11:54:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
In-Reply-To: <48A05F4D.4080404@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808111152060.30842@gandalf.stny.rr.com>
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
 <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro> <48A046F5.2000505@linux-foundation.org> <1218463774.7813.291.camel@penberg-laptop> <48A048FD.30909@linux-foundation.org> <alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com>
 <48A04EC2.1080302@linux-foundation.org> <y0mhc9ra7m6.fsf@ton.toronto.redhat.com> <48A05F4D.4080404@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 Aug 2008, Christoph Lameter wrote:

> Frank Ch. Eigler wrote:
> > Christoph Lameter <cl@linux-foundation.org> writes:
> > 
> >> [...]
> >>> There should be no extra function calls when this is configured on but 
> >>> tracing disabled. We try very hard to keep the speed of the tracer as 
> >>> close to a non tracing kernel as possible when tracing is disabled.
> >> Makes sense. But then we have even more code bloat because of the
> >> tests that are inserted in all call sites of kmalloc.
> > 
> > Are you talking about the tests that implement checking whether a
> > marker is active or not?  Those checks are already efficient, and will
> > get more so with the "immediate values" optimization in or near the
> > tree.
> 
> AFAICT: Each test also adds an out of line call to the tracing facility.
> 

Frank,

Christoph is correct. He's not bringing up the issue of efficiency, but 
the issue of bloat.

The marker code will be added to everyplace that calls kmalloc. Which can 
be quite a lot.  I'd be interested in seeing the size of the .text section 
with and without this patch added and makers configure in.

-- Steve

