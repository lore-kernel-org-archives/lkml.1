Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXCZL6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXCZL6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXCZL6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:58:04 -0400
Received: from aun.it.uu.se ([130.238.12.36]:48397 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbXCZL6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:58:01 -0400
Date: Mon, 26 Mar 2007 13:57:29 +0200 (MEST)
Message-Id: <200703261157.l2QBvTJg011821@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, khali@linux-fr.org
Subject: Re: [PATCH 1/2] MSR: Add support for safe variants
Cc: adobriyan@openvz.org, davej@redhat.com, linux-kernel@vger.kernel.org,
       r.marek@assembler.cz
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 13:29:37 +0200, Jean Delvare wrote:
> * * * * * Updated patch * * * * *
> 
> From: Rudolf Marek <r.marek@assembler.cz>
> 
> Add safe (exception handled) variants of rdmsr_on_cpu and wrmsr_on_cpu.
> You should use these when the target MSR may not actually exist, as
> doing so could trigger an exception which the regular functions do not
> handle. The safe variants are slower, though.
> 
> The upcoming coretemp hardware monitoring driver will need this.

Maybe I'm in the minority here, but I for one strongly believe
that any attempt to access an MSR "which might not be there" is
inherently wrong. It implies that your HW detection is incomplete,
which in combination with MSR accesses means that you may end up
accessing MSRs that aren't at all what you think they should be.

Who supplies these imprecise MSR definitions anyway?
Intel manuals? ACPI?

/Mikael
