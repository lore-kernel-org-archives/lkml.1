Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbYGQXNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbYGQXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933008AbYGQXMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:12:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760668AbYGQXMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:12:45 -0400
Message-ID: <487FD1D9.9020100@kernel.org>
Date: Thu, 17 Jul 2008 16:12:25 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not grow initial process stack so much
References: <200807162332.37741.vda.linux@googlemail.com>
In-Reply-To: <200807162332.37741.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> 
> I do not see, though, why this can be useful for x86. The pages
> are not mapped anyway, so accessing them still causes page faults.
> No speedup for, say, rapidly spawning processes which need ~60k
> of stack right away. They will still fault in kernel, right?
> 

They will fault in the kernel, but only to fill the page tables, so it 
would cut down on latency.

I do *NOT* believe we should make this an x86-only change.  If it should 
be architecture-dependent I'd rather find the architectures that do need it.

However, before changing this I really want to see some of the history 
about why it's that way in the first place.

	-hpa
