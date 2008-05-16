Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYEPVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYEPVgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYEPVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:36:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYEPVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:36:10 -0400
Message-ID: <482DFD65.10300@zytor.com>
Date: Fri, 16 May 2008 14:32:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix immediate asm constraint for gcc 3 x86_64
References: <482AB6C5.4060604@goop.org> <20080516124811.GC4226@Krystal>
In-Reply-To: <20080516124811.GC4226@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:

> 
> It seems that include/asm-x86/immediate.h in sched-devel.git causes
> this. gcc-3.4 does not seem to like the "i" (&name##__imv) constraint. I
> have seen no such problem with gcc-4.1. This is weird. It seems that
> relaxing the constraint helps fixing this, but it's not clear whether
> fixing the code or gcc-3.4 is the correct solution... here is the fix :
> 
> Fix immediate asm constraint for gcc 3 x86_64
> 

It might make it compile, but it's completely *wrong* for the purpose 
intended.

It permits gcc to present the address in a register, for example, so 
there is no guarantee that you end up with an immediate.

	-hpa
