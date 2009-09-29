Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZI2UqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZI2UqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZI2UqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbZI2UqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:46:09 -0400
Date: Tue, 29 Sep 2009 13:46:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: augment /proc/pid/limits to allow setting of
 process limits (v2).
Message-Id: <20090929134603.3935b149.akpm@linux-foundation.org>
In-Reply-To: <20090929202504.GC20420@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org>
	<20090928154403.25678002.akpm@linux-foundation.org>
	<20090929202504.GC20420@hmsreliant.think-freely.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 16:25:04 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> 3) modify the proc/pid/limits write routine so that it uses do_setrlimit,
> thereby giving us the previously missing security checks.

I dunno, the interface just seems goofy to me.

Yes, it's always been strange that rlimits cannot be externally
altered.  And desirable to extend that.  But doing what is really a
syscall via a profs poke when there already exists a syscall which does
the same thing seems Just Wrong.

What reason is there to do it via procfs?  Where's the benefit?

Maybe it's a plot to stop people from setting CONFIG_PROC_FS=n.
