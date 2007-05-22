Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXEVKhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXEVKhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbXEVKhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:37:34 -0400
Received: from www.osadl.org ([213.239.205.134]:45340 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbXEVKhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:37:33 -0400
Subject: Re: [PATCH] i386: fix early usage of atomic_add_return and
	local_add_return on real i386
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200705221234.28289.ak@suse.de>
References: <1179827338.12708.110.camel@chaos>
	 <200705221234.28289.ak@suse.de>
Content-Type: text/plain
Date: Tue, 22 May 2007 12:37:28 +0200
Message-Id: <1179830248.12708.120.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 12:34 +0200, Andi Kleen wrote:
> On Tuesday 22 May 2007 11:48, Thomas Gleixner wrote:
> > The check (boot_cpu_data.x86 == 3) in atomic_add_return() and
> > local_add_return() fails, when those operations are used before
> > boot_cpu_data is filled in.
> >
> > Change the check to (boot_cpu_data.x86 <= 3) to fix this.
> 
> That's a critical boot fix for 386, right?

Yup. Hit me with some debug option enabled, but might happen anywhere
else too.

	tglx


