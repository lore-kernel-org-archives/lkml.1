Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYAVSfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYAVSfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYAVSfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:35:12 -0500
Received: from ns.suse.de ([195.135.220.2]:55696 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYAVSfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:35:11 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Date: Tue, 22 Jan 2008 14:33:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <p73hcha9vc5.fsf@bingen.suse.de> <20080119160743.GA8352@csn.ul.ie>
In-Reply-To: <20080119160743.GA8352@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221433.29771.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Without SRAT support, a compile-error occurs because ACPI table parsing
> functions are only available in x86-64. This patch also adds no-op stubs
> and prints a warning message. What likely needs to be done is sharing
> the table parsing functions between 32 and 64 bit if they are
> compatible.

I'm a little confused by your patch.

i386 already has srat parsing code (just written in a horrible hackish way); 
but it exists arch/x86/kernel/srat_32.c

That one tended to explode on Opteron, but apparently worked on some 
Summit boxes.

You're saying you want to remove that code and replace it based on something
based on the drivers/acpi/numa.c parsing code? While that's in theory
a worthy goal it will not actually help all that much because numa.c only
does some high level parsing, but nothing of the actual low level work
of setting things up.

-Andi
