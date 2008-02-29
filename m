Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbYB2Qa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbYB2Qa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYB2Qaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:30:46 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:21591 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYB2Qap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OfH1aeWPRDtmpcFjKuGU2/9Lho49j/3dGBSBOMQns4+jmPpN7Hcya+I3WIpwtHrQ6Aws82BPwwAOdCb8+IhKerq+7zCPOxpQnYYscJUm0rKPyA2EiG7UbAdDOrFkFOUGtRxkIgiF26a7OfxeQOi3luji9NWAx/cnZYDChvG0bkk=
Message-ID: <590657100802290830y1e4786adi1411e8a4e4b277f4@mail.gmail.com>
Date: Fri, 29 Feb 2008 08:30:43 -0800
From: "Harvey Harrison" <harvey.harrison@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080229031656.1abac83a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202007623.1844.44.camel@brick>
	 <20080229031656.1abac83a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 3:16 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 02 Feb 2008 19:00:23 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:
>
>  > Use a central kprobe_handle_fault() inline in kprobes.h to remove
>  > all of the arch-dependant, practically identical implementations in
>  > avr32, ia64, powerpc, s390, sparc64, and x86.
>  >
>  > avr32 was the only arch without the preempt_disable/enable pair
>  > in its notify_page_fault implementation.
>  >
>  > This uncovered a possible bug in the s390 version as that purely
>  > copied the x86 version unconditionally passing 14 as the trapnr
>  > rather than the error_code parameter.  s390 is changed to pass
>  > error_code in this patch.
>  >
>  > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>  > ---
>  > Andrew, 1/2 is low risk, 2/2 has been tested on x86-32 and 64,
>  > but the !preemptible invariant seems correct.
>  >
>  >  arch/arm/mm/fault.c     |   25 +------------------------
>  >  arch/avr32/mm/fault.c   |   21 +--------------------
>  >  arch/ia64/mm/fault.c    |   24 +-----------------------
>  >  arch/powerpc/mm/fault.c |   25 +------------------------
>  >  arch/s390/mm/fault.c    |   25 +------------------------
>  >  arch/sparc64/mm/fault.c |   23 +----------------------
>  >  arch/x86/mm/fault.c     |   26 ++------------------------
>  >  include/linux/kprobes.h |   20 ++++++++++++++++++++
>  >  8 files changed, 28 insertions(+), 161 deletions(-)
>
>  Breaks the ia64 build:
>
>  include/linux/kprobes.h: In function `kprobe_handle_fault':
>  include/linux/kprobes.h:234: error: implicit declaration of function `kprobe_fault_handler'
>
>  and ia64 doesn't implement kprobe_fault_handler() so there's no easy fix
>  here.

Yes there is, ia64 apparently called theirs kprobes_handle_fault, sorry I didn't
notice the extra 's'.  Want a new patch, or will you change the three
occurances?

Harvey
