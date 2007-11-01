Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbXKAPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbXKAPbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbXKAPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:31:19 -0400
Received: from gw.goop.org ([64.81.55.164]:34286 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761570AbXKAPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:31:18 -0400
Message-ID: <4729F133.3060308@goop.org>
Date: Thu, 01 Nov 2007 08:30:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com, tglx@linutronix.de,
       jun.nakajima@intel.com, glommer@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit paravirt
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <47295AA7.9090507@goop.org> <4729D92E.2030108@redhat.com>
In-Reply-To: <4729D92E.2030108@redhat.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> I in fact have seen bugs with mixed reads and writes to the same cr,
> (cr4), but adding the volatile
> flag to the read function seemed to fix it.

Well, volatile will make a read be repeated rather than caching the
previous value, but it has no effect on ordering.

> Yet, I agree with you that
> the theorectical problem exists for the reorder, and your proposed fix
> seems fine (although if we're really desperate about memory usage, we
> can use a char instead a int and save 3 bytes!)

Sure.  Ideally the compiler would never even generate a reference to it,
and it could just be extern, but in practice the compiler will generate
references sometimes.

    J
