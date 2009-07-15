Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZGOKds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZGOKds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZGOKds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:33:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41763 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbZGOKdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:33:46 -0400
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
	all .data.* sections on X86_64)
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       linux-ext4@vger.kernel.org
In-Reply-To: <20090715080336.GA4823@skywalker>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
	 <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
	 <4A5C5FD0.3020204@fisher-privat.net>
	 <1247574390.28240.67.camel@pc1117.cambridge.arm.com>
	 <20090715080336.GA4823@skywalker>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 15 Jul 2009 11:33:15 +0100
Message-Id: <1247653995.10407.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2009 10:33:17.0007 (UTC) FILETIME=[AA2FA5F0:01CA0537]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 13:33 +0530, Aneesh Kumar K.V wrote:
> Can you try this patch ?
[...]
>     ext4: Memory leak fix ext4_group_info allocation.
>     
>     commit 5f21b0e642d7bf6fe4434c9ba12bc9cb96b17cf7  was done to
>     reallocate groupinfo struct during resize properly. That goal
>     was to allocate new groupinfo struct when we are adding new block
>     groups during resize. Calling ext4_mb_add_group_info in the
>     mballoc initialization code path resulted in we reallocating
>     the group info struct . Fix this by not separately allocating
>     group info in the mballoc init path and always depend on
>     ext4_mb_add_group_info to allocate group info struct.
>     
>     The earlier code also had a bug that we allocated less number of
>     group info struct for the last meta group. But on resize we
>     expected that we had EXT4_DESC_PER_BLOCK group info struct for
>     each meta group.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The kmemleak report disappeared.

Tested-by: Catalin Marinas <catalin.marinas@arm.com>

BTW, there are a few compiler warnings about unused variables with this
patch.

-- 
Catalin

