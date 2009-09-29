Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZI2Xrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZI2Xrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZI2Xrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:47:42 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:58220 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI2Xrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:47:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mC4suecGCbYh/qBCdLOjuIwk/mfVK3naqpNbozCkTnEgDP+ap/qAE4z/uT6XowDoEA
         TzCXrnlQcWb/h1hhg2zGxdNV83YK8ELlWflymnigmm4u11HRBhBpeU6hdXYDA3N0Ekb+
         Vyk7Gbuyh+GRCMTT/9mBg1rfHr4G7Hin+EmZk=
MIME-Version: 1.0
Date: Tue, 29 Sep 2009 16:47:45 -0700
Message-ID: <90201b70909291647j1a1ebf4do12c1495ad3aa76e4@mail.gmail.com>
Subject: In PAE enabled kernel, ioremap cannot handle physical address > 32bit
From: Sean Brandenburger <seanbrandenburger@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   I have a PAE enabled kernel. I am trying to ioremap a physical address
which is above 4GB area. It is noticed that the ioremap maps to the 32bit
truncated physical address.

   Even though __ioremap_caller takes in phys_addr of size
resource_size_t, the macro PAGE_SHIFT, PAGE_MASK truncates the
size to 32bit on the physical address operand it works on (for e.g. pfn,
phys_addr, last_addr, etc. below)

         /*
          * Don't allow anybody to remap normal RAM that we're using..
          */
         for (pfn = phys_addr >> PAGE_SHIFT;
                                 (pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
                                 pfn++) {

   Even after fixing the above lines, still the issue is there. Looks
like there
is lot more places fixes to handle greater than 32bit need to be done.
I searched the past mailing list and did not find any fixes. I did come across
suggestions not to use PAGE_MASK on Physical address but to use
PHYSICAL_PAGE_MASK. I did come cross other fixes related to handling
physical address greater than 32bit but not any fixes for ioremap.

   Does any of you know if this issue has been fixed? If not, I will spend
time to fix it.

Thanks
Sean
