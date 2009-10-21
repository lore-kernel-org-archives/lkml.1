Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZJUGwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZJUGwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZJUGwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:52:21 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:53155 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752229AbZJUGwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:52:20 -0400
Date: Wed, 21 Oct 2009 02:43:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       peterc@gelato.unsw.edu.au
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <4ADDC1FC.8010903@kernel.org>
Message-ID: <alpine.DEB.1.10.0910210236360.9745@gentwo.org>
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de> <20091020063555.GJ8550@elte.hu>
 <4ADDB640.4020707@suse.com> <20091020134308.GA3930@elte.hu> <4ADDC1C6.9090305@kernel.org> <4ADDC1FC.8010903@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The suggestion to Tony was to stop using the fixed TLB address for the per
cpu areas and instead use a global register like on x86 and sparc. Peter
Chubb then said that we had available global registers (cced him) that
could be used for this purpose. Doing so would make percpu support conform
to the schemes used by other architectures.

However, IA64 supports TLBs for larger pages (128MB, 256MB ...). So we
could change the maximum size of the static percpu data by using a
different sized TLB entry.

Tony?
