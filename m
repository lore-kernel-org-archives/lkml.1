Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbYHKPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbYHKPui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYHKPua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:50:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYHKPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:50:29 -0400
Message-ID: <48A05F4D.4080404@linux-foundation.org>
Date: Mon, 11 Aug 2008 10:48:29 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>	<1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>	<1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>	<1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>	<1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>	<48A046F5.2000505@linux-foundation.org>	<1218463774.7813.291.camel@penberg-laptop>	<48A048FD.30909@linux-foundation.org>	<alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com>	<48A04EC2.1080302@linux-foundation.org> <y0mhc9ra7m6.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0mhc9ra7m6.fsf@ton.toronto.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Christoph Lameter <cl@linux-foundation.org> writes:
> 
>> [...]
>>> There should be no extra function calls when this is configured on but 
>>> tracing disabled. We try very hard to keep the speed of the tracer as 
>>> close to a non tracing kernel as possible when tracing is disabled.
>> Makes sense. But then we have even more code bloat because of the
>> tests that are inserted in all call sites of kmalloc.
> 
> Are you talking about the tests that implement checking whether a
> marker is active or not?  Those checks are already efficient, and will
> get more so with the "immediate values" optimization in or near the
> tree.

AFAICT: Each test also adds an out of line call to the tracing facility.
