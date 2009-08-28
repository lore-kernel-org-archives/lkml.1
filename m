Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZH1Tt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZH1Tt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZH1Tt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:49:28 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:24923 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZH1Tt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:49:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIvRl0qrR7O6/2dsb2JhbADBfohAAZAfBYQZ
X-IronPort-AV: E=Sophos;i="4.44,292,1249257600"; 
   d="scan'208";a="234603006"
From: Roland Dreier <rdreier@cisco.com>
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
References: <812804.57438.qm@web45209.mail.sp1.yahoo.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 28 Aug 2009 12:49:29 -0700
In-Reply-To: <812804.57438.qm@web45209.mail.sp1.yahoo.com> (joe Shmoe's
	message of "Fri, 28 Aug 2009 11:40:56 -0700 (PDT)")
Message-ID: <ada4orrra5y.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Aug 2009 19:49:29.0746 (UTC) FILETIME=[A8107F20:01CA2818]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > But my question is with regard to setting up the page tables during the kernel initialization in such a way so that entire RAM upto 4GB can be mapped. i.e virtual to physical address mapping. My question is strictly with reg. to physical address mapping only.
 > 
 > Why does kernel stop at 1GB (896 MB to be exact) while mapping from linear to physical address. 

Because it wants to be able to give userspace 3GB of address space.  And
userspace mapping cannot be a linear mapping to physical memory -- it
must be real virtual memory that has proper access permissions and can
handle mmap'ed files, shared libraries, etc etc.  So userspace cannot
share the kernel's linear mapping.
