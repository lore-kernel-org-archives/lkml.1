Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYGIWMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYGIWMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYGIWL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:11:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53672 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYGIWL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:11:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<20080709165129.610711000@polaris-admin.engr.sgi.com>
Date: Wed, 09 Jul 2008 15:02:45 -0700
In-Reply-To: <20080709165129.610711000@polaris-admin.engr.sgi.com> (Mike
	Travis's message of "Wed, 09 Jul 2008 09:51:31 -0700")
Message-ID: <m14p6ysol6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0303]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 02/15] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> WARNING: there is still a FIXME in this patch (see arch/x86/kernel/acpi/sleep.c)
>
>   * Declare the pda as a per cpu variable.
>
>   * Make the x86_64 per cpu area start at zero.
>
>   * Relocate the initial pda and per_cpu(gdt_page) in head_64.S for the
>     boot cpu (0).  For secondary cpus, do_boot_cpu() sets up the correct
>     initial pda and gdt_page pointer.
>
>   * Initialize per_cpu_offset to point to static pda in the per_cpu area
>     (@ __per_cpu_load).
>
>   * After allocation of the per cpu area for the boot cpu (0), reload the
>     gdt page pointer.
>
> Based on linux-2.6.tip/master

Given that we have not yet understood the weird failure case.  This patch needs
to be split in two.  
- make the current per cpu variable section zero based.
- Move the pda into the per cpu variable section.

There are too many variables at present the reported failure cases to
guess what is really going on.

We can not optimize the per cpu variable accesses until the pda moves
but we can easily test for linker and tool chain bugs with zero
based pda segment itself.

Eric
