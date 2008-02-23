Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbYBWTDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbYBWTDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYBWTCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:02:52 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbYBWTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:02:51 -0500
Date: Sat, 23 Feb 2008 11:01:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-Id: <20080223110158.62a3ad6e.akpm@linux-foundation.org>
In-Reply-To: <84144f020802230654y3913447bh39390fdd78a96cf3@mail.gmail.com>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<20080223001130.d8922136.akpm@linux-foundation.org>
	<84144f020802230654y3913447bh39390fdd78a96cf3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 16:54:49 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >  Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not if
> >  your distributor already did it for you.
> >
> >  Sidebar: the code uses the utterly crappy register_timer_hook() which
> >
> >  a) is woefully misnamed and
> >
> >  b) is racy and
> >
> >  c) will disrupt oprofile if it is being used.  And vice versa.
> 
> I wonder if sysprof should hook to the same interrupt as oprofile then?

oprofile uses register_timer_hook() for its oh-crap-nothing-else-works
fallback iirc.  It's a useful fallback: I used it a few centuries ago on
some el-cheapo VIA CPU-based thing we had at Digeo.

It's unclear to me whether all this stuff works with NO_HZ=y, btw.  Didn't
we just lose the regular timer interrupts which these clients depend upon?

