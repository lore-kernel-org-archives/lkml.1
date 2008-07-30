Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYG3BlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYG3BlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYG3BlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:41:06 -0400
Received: from ozlabs.org ([203.10.76.45]:49335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYG3BlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:41:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: module-placed markers/tracepoints
Date: Wed, 30 Jul 2008 11:40:59 +1000
User-Agent: KMail/1.9.9
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20080717155724.897537670@polymtl.ca> <20080729211543.GB17097@redhat.com> <20080729224115.GA5209@Krystal>
In-Reply-To: <20080729224115.GA5209@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301140.59745.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 08:41:16 Mathieu Desnoyers wrote:
> Therefore, what would be needed here is to add a synchronize_sched()
> after mod->exit() in module.c or after each tracepoint/marker unregister
> in marker.c/tracepoint.c. However, I'd really prefer to add this to
> module.c since adding this for _every_ unregister will slow down
> processing or multiple probe unregistration too much.
>
> Rusty, am I understanding that correctly ?
>
> Mathieu

Hi Mathieu,

   Yes: stop_machine is merely used to atomically check the module refcount 
for zero and set the state so it can't be incremented again (ie. 
try_module_get will fail).

   So placing a tracepoint or marker in a module does not bump the module 
refcount?  If that's true, then there needs to be some kind of 
remove_markers_from_module() call after module->exit(), which should do the 
synchronize_sched() or whatever, right?

Rusty.
