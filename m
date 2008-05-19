Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbYESVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbYESVRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYESVRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:17:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbYESVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:17:06 -0400
Message-ID: <4831EE48.5050908@firstfloor.org>
Date: Mon, 19 May 2008 23:16:56 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86: don't destroy %rbp on kernel-mode faults
References: <20080519200230.GA12210@damson.getinternet.no>
In-Reply-To: <20080519200230.GA12210@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
> 
> The RFC part of this patch is: Does anybody see why touching %rcx would
> be bad? It certainly looks like %ecx is free. This fixes the stacktrace
> problem I was seeing, and Pekka tested a bootup to userspace. (Pekka also
> did half of the debugging. When will git allow multiple authors for a
> patch? :-))

The patch is ok, but I'm sure there's lots of other assembler code that
destroys %rbp when it was saved elsewhere.

When I wrote all the assembler the assumption was always that a real
unwinder would be used for backtraces, not frame pointer.

-Andi
