Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZBSACe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZBSACe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZBSACZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:02:25 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:39026 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbZBSACY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:02:24 -0500
Subject: Re: [PATCH 3/9] x86/paravirt: remove lazy mode in interrupts
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <06944a6dbc4ea222760d39d3d0156e50102f8196.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
	 <06944a6dbc4ea222760d39d3d0156e50102f8196.1234988621.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 16:53:57 -0800
Message-Id: <1235004837.6951.6.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 14:30 -0800, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Make paravirt_lazy_mode() always return PARAVIRT_LAZY_NONE
> when in an interrupt.  This prevents interrupt code from
> accidentally inheriting an outer lazy state, and instead
> does everything synchronously.  Outer batched operations
> are left deferred.

This looks like a good solution, but can you make paravirt_lazy_mode()
inline?  It doesn't need to be a function call.

Zach

