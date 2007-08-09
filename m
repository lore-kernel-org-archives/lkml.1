Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXHIKGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXHIKGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 06:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXHIKGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 06:06:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:51589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXHIKGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 06:06:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: EFI e820 map handling
Date: Thu, 9 Aug 2007 12:06:37 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091206.37302.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hallo,

I thought a bit about the zero page problem. I really would prefer to not
having it used in a boot loader right now because it's not extensible anymore
when external users start (ab)using it.

When I asked for separate EFI->e820 functions I was really thinking
of the kernel to do the conversion; not the boot loader.

Could you move that code into the kernel early boot code please? 
e.g. on x86-64 it could be in head64.c.  It could stuff the result
into the zero page to pass it cleanly on without special cases later.

On i386 a head32.c that runs before start_kernel() could be also 
introduced for this.

As long as it's localized there it is fine.

This would also allow to define new private e820 types and extend
the string decoding in e820; so that dmesg will correctly contain

EFI: ....

instead of

BIOS-e820: ... 

Thanks,

-Andi
 
