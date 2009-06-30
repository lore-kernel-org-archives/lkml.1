Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbZF3XWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbZF3XWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761101AbZF3XVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:21:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761063AbZF3XVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:21:34 -0400
Message-ID: <4A4A9DC6.6020003@kernel.org>
Date: Wed, 01 Jul 2009 08:20:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906301809330.11362@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:20:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

Christoph Lameter wrote:
> I looked at allocating for online cpus only a couple of years back but at
> that per cpu state was kept for offlined cpus in per cpu areas. There are
> numerous assumptions in per cpu handling all over the kernel that a percpu
> area is always available.

The plan is to allocate and keep percpu areas for cpus which have ever
been up.  There'll be no taking down of percpu areas.  Conversion from
possible to has_ever_been_up should be much easier than possible ->
online.  State keeping will work fine too.

> We successfully restricted it to only possible
> cpus. ACPI may be the worst offender there. If you can get all of that
> addressed then we can move to pure on demand allocation. Which also would
> complicate a per cpu memory allocator allocator.

I don't think it will be too complex.  The necessary bits are already
there and they are necessary for other stuff too, so...

Thanks.

-- 
tejun
