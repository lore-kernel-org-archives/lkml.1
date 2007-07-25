Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbXGYHFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbXGYHFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXGYHF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:05:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbXGYHF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:05:29 -0400
Date: Wed, 25 Jul 2007 00:05:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Lalancette <clalance@redhat.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]: Add command-line option to i8042 to completely disable
 it
Message-Id: <20070725000504.f8ce49c1.akpm@linux-foundation.org>
In-Reply-To: <46A4DFD2.2010501@redhat.com>
References: <46A4DFD2.2010501@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 13:05:22 -0400 Chris Lalancette <clalance@redhat.com> wrote:

> (I tried to send this patch to linux-input@, but it seems to be currently having
> some problems, so I'm going directly to LKML).
> 
> Certain (broken) pieces of South Bridge hardware will respond to
> i8042_read_status() on boot with 0x0, despite there not being a real i8042
> controller hooked up in the south bridge.  This can cause the detection for the
> i8042 to return a "phantom" device, which hangs up later initialization.  Note
> that using "i8042.nokbd" and/or "i8042.noaux" do not help with this, since this
> shows up during i8042_controller_check() (before either of those options are
> checked).  This patch adds a command-line option "i8042.disable", which just
> completely disables any checking for the i8042 controller.

That's an unfortunate fix.  Is there really no way in which we
can auto-detect such a situation without requiring a manual
setting?
