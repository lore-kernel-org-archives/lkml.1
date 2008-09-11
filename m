Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYIKSg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYIKSg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYIKSgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:36:49 -0400
Received: from gw.goop.org ([64.81.55.164]:60854 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYIKSgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:36:49 -0400
Message-ID: <48C9653F.1090805@goop.org>
Date: Thu, 11 Sep 2008 11:36:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu> <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org> <20080911073337.GF27877@elte.hu>
In-Reply-To: <20080911073337.GF27877@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> the false positive should be avoided, for example by unmapping the 
> 'prev' mapping shortly before the leak check.
>   

Yep.  I'll make it unmap just before setting acpi_gbl_permanent_mmap,
which is when it switches to using plain old ioremap.

>> (All those other backtraces are just informational, right?)
>>     
>
> no, they cause hard failures in my test setup. Nor do we want to litter 
> the bootup log with messages that are not correct.
>   

No, I mean that early_ioremap_debug causes all early_ioremap()s to dump
a stack trace, so most of the stack dumps in the boot log are
diagnostic/informational rather than indications of lots of problems.

    J
