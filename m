Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbXLYRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbXLYRHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 12:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXLYRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 12:07:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:53756 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXLYRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 12:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=C+i6m3xXHDPvD0MAEItv4OaIIYrs2tdrmHT992hd3RWyyu1PWgePetsJSgsS6wNNq2ny5w1opVqhsOXL1v/SdO80iVSxSMkhWbGnX6SE2fup63OmJdRHwSzCfRfy4dU9yxNFIa4fvj4dQYxJuWCTzEpHAcPZz6Mz65dhcPTCtYQ=
Date: Tue, 25 Dec 2007 20:07:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [x86] is checkpatch.pl broken
Message-ID: <20071225170737.GA3887@cvg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

by doing cleanup of arch/x86/boot/*.[ch] i found that
checkpatch does ignore obvious things. For example,
run it over edd.c showed only one warning:

---
cyrill@cvg linux-2.6.git $ scripts/checkpatch.pl --file arch/x86/boot/edd.c 
WARNING: externs should be avoided in .c files
#45: FILE: x86/boot/edd.c:45:
+       extern char _end[];

total: 0 errors, 1 warnings, 167 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
---

but on line 53 we have:

mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);

so checkpatch should at least worn me about missed space
btw math operators. Am I wrong?


--
BTW, is there someone who is already involved in a such
cleanup to eliminate double effort?

			- Cyrill -

