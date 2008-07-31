Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYGaAyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYGaAyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYGaAyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:54:39 -0400
Received: from ozlabs.org ([203.10.76.45]:35579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYGaAyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:54:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Module : call synchronize_sched() between module exit() and free.
Date: Thu, 31 Jul 2008 10:54:33 +1000
User-Agent: KMail/1.9.9
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20080717155724.897537670@polymtl.ca> <20080730114035.GD27711@redhat.com> <20080730140938.GC18210@Krystal>
In-Reply-To: <20080730140938.GC18210@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311054.34557.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 00:09:38 Mathieu Desnoyers wrote:
> * Frank Ch. Eigler (fche@redhat.com) wrote:
> >(Would it not be desirable for an active marker to cause
> > module-foo's refcount to increase, so as to prevent unloading at this
> > time?)
>
> No, because I want to be able to unload the marked module and I don't
> want the fact that a probe is connected to it to change that.

Also you might want to put a marker in the module's exit code.

> Actually there is a detail missing here. Your teardown should be :
>  teardown() { ... marker_probe_unregister ("foo" , ..., &foo_handler );
>                   synchronize_sched(); /* Before returning from exit */ }
>
> This makes sure that every live marker call are finished and that it is
> safe to unload module-bar (the probe).

Perhaps create a synchronize_marker_unregister() wrapper for such uses; it's 
better documentation and the caller doesn't have to know exactly how it 
works...

Cheers,
Rusty.
