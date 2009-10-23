Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZJWPan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZJWPan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZJWPan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:30:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZJWPam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:30:42 -0400
Date: Fri, 23 Oct 2009 17:30:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Erwan Velu <erwanaliasr1@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI
	table is present
Message-ID: <20091023153027.GA18068@elte.hu>
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu> <4AE19867.5070705@gmail.com> <1256302066.10493.74.camel@desktop> <4AE1C5C6.7000103@gmail.com> <1256310576.10493.78.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1256310576.10493.78.camel@desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@fifo99.com> wrote:

> On Fri, 2009-10-23 at 17:03 +0200, Erwan Velu wrote:
> > Daniel Walker a écrit :
> > > [...]
> > > It's your defect, so you can still try to fix it (unless the "xen
> > > people" or someone else beats you to it.) 
> > >
> > > It looks like on a normal system dmi_scan_machine() gets called very
> > > early in setup_arch() arch/x86/kernel/setup.c . A possible good fix
> > > might be to add a dmi_disable() into the dmi driver that just shuts off
> > > dmi, and run that in xen_arch_setup() in arch/x86/xen/setup.c 
> > Could it make sense having this patch (I can work on it) while keeping 
> > my previous patch ?
> > Does it make sense keeping the default return value I've been adding 
> > when no dmi table is found ?
> 
> Ingo mentioned that the returning mechanism your adding was left out 
> intentionally to catch this error, so I don't think your original 
> patch could be included ..

Yes. That mechanism found a real bug here.

Calling the DMI code too early (when the strings are still empty) can 
cause silent failures: we wont crash but we might miss to act on DMI 
quirks.

	Ingo
