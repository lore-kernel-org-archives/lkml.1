Return-Path: <linux-kernel-owner+w=401wt.eu-S1161000AbXCGAZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161000AbXCGAZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161001AbXCGAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:25:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161000AbXCGAZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:25:53 -0500
Date: Tue, 6 Mar 2007 16:25:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: discuss@x86-64.org, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] optimize and simplify get_cycles_sync()
Message-Id: <20070306162541.2b8a148d.akpm@linux-foundation.org>
In-Reply-To: <20070228142554.GE19452@amd.com>
References: <20070228140501.GA19452@amd.com>
	<20070228142554.GE19452@amd.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 15:25:54 +0100
"Joerg Roedel" <joerg.roedel@amd.com> wrote:

> From: Joerg Roedel <joerg.roedel@amd.com>
> 
> This patch simplifies the get_cycles_sync() function by removing the
> #ifdefs from it. Further it introduces an optimization for AMD
> processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
> which is helpfull if the kernel runs as a KVM guest. Running as a guest
> makes CPUID very expensive because it causes an intercept of the guest.

Problem:

http://test.kernel.org/functional/index.html

lots of builds fell over because their binutils versions don't understand
rdtscp.

I don't know how recently rdtscp support was added to binutils, but
this is likely to be a problem.  Perhaps we can change this patch to
embed the hex code for that opcode instead?
