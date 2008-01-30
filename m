Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYA3SVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYA3SVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYA3SVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:21:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44602 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYA3SVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:21:10 -0500
Date: Wed, 30 Jan 2008 10:20:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       "Jan Beulich" <jbeulich@novell.com>, pq@iki.fi
Subject: Re: [PATCH] x86: Add a list for custom page fault handlers.
Message-ID: <20080130102047.59aae047@laptopd505.fenrus.org>
In-Reply-To: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 18:52:38 +0200
Pekka Paalanen <pq@iki.fi> wrote:

> From: Pekka Paalanen <pq@iki.fi>
> 
> Provides kernel modules a way to register custom page fault handlers.
> On every page fault, except those handled in vmalloc_fault(), this
> will call a list of registered functions. The functions may handle
> the fault and force do_page_fault() to return immediately.
> 
> This functionality is similar to the now removed page fault notifiers.
> Custom page fault handlers are used by debugging and reverse
> engineering tools. Mmio-trace is one such tool and a patch to add it
> into the tree will follow.
> 
> The custom page fault handlers are called from the exact same points
> in do_page_fault() as the page fault notifiers were.

to be honest I don't like this approach.
I fully would like to see mmio tracing in the kernel, but please 
make the hook explicit and direct (eg call the mmio tracing function,
not some list) instead...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
