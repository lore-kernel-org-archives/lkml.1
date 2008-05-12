Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYELJWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYELJWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbYELJW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:22:28 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:46715 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbYELJW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HFtjgAPoYioFN8omWYbe67l8snBWH7MwR1rdxmqGocBkDd04Abu3nsA9Y8Ug8AsGnw6Pce1kAJG6WSRR9x6H/eaQdXIyjzKFQ9OPDtwjWF065fBzKmPZ8/jRZUkztZbxuxNbSbo5ND1Mww7hVLRc/39q54tmk6ktdCGoIs+pmDQ=
Message-ID: <430c80e90805120222u45dac846j96c4a1810114b94d@mail.gmail.com>
Date: Mon, 12 May 2008 14:52:26 +0530
From: "Pranith Kumar" <bobby.prani@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [Patch 1/1] Trivial - 2.6.26-rc2, arch/x86/mm/pat.c - fix warning
Cc: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Kernel List" <kernelnewbies@nl.linux.org>,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get this warning when i compile the latest rc2
arch/x86/mm/pat.c: In function `phys_mem_access_prot_allowed':
arch/x86/mm/pat.c:558: warning: long long unsigned int format, long
unsigned int arg (arg 6)
arch/x86/mm/pat.c: In function `map_devmem':
arch/x86/mm/pat.c:580: warning: long long unsigned int format, long
unsigned int arg (arg 6)

The following patch fixes this warning

Signed-Off-by: D Pranith Kumar <bobby.prani@gmail.com>

--- linux-2.6.26-rc2/arch/x86/mm/pat.c.orig	2008-05-12 14:25:16.000000000 +0530
+++ linux-2.6.26-rc2/arch/x86/mm/pat.c	2008-05-12 14:24:05.000000000 +0530
@@ -555,7 +555,7 @@ int phys_mem_access_prot_allowed(struct
 		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
 			current->comm, current->pid,
 			cattr_name(flags),
-			offset, offset + size);
+			offset, (unsigned long long)(offset + size));
 		return 0;
 	}

@@ -576,7 +576,7 @@ void map_devmem(unsigned long pfn, unsig
 		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
 			current->comm, current->pid,
 			cattr_name(want_flags),
-			addr, addr + size,
+			addr, (unsigned long long)(addr + size),
 			cattr_name(flags));
 	}
 }
