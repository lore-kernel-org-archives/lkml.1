Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZBXQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZBXQH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbZBXQHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:07:09 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54657 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZBXQHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:07:07 -0500
Subject: Re: [RFC v13][PATCH 05/14] x86 support for checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090224014739.1b82fc35@thinkcentre.lan>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1233076092-8660-6-git-send-email-orenl@cs.columbia.edu>
	 <20090224014739.1b82fc35@thinkcentre.lan>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 08:06:46 -0800
Message-Id: <1235491606.26788.248.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 01:47 -0600, Nathan Lynch wrote:
> But I think this has been pointed out before.  If I understand the
> justification for cr_hbuf_get correctly, the allocations it services
> are somehow known to be bounded in size and nesting.  But even if that
> is the case, it's not much of a reason to avoid using kmalloc, is it?

Oren wants this particular facility to be used for live migration.  To
support good live migration, we need to be able to return from the
syscall as fast as possible.  To do that, Oren proposed that we buffer
all the data needed for the checkpoint inside the kernel.

The current cr_hbuf_put/get() could easily be modified to support this
usage by basically making put() do nothing, then handing off a handle to
the cr_ctx structure elsewhere in the kernel.  When the time comes to
free up the in-memory image, you only have one simple structure to go
free (the hbuf) as opposed to a bunch of little kmalloc()'d objects.

I'm sure I'm missing something.  I'm also sure that this *will* work
eventually.  But, I don't think the code as it stands supports keeping
the abstraction in there.  It is virtually impossible to debate the
design or its alternatives in this state.

-- Dave

