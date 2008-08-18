Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYHRSoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYHRSoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbYHRSnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:43:52 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53343 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbYHRSnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MYTtUwk9cDoHV6eSa17bmXvsIupTjEubY2XWLedQ/kzEQGuX/BGhfy7I9u4UdVsxEc
         mf7D+82/ljt3F/ltzXFalPtayIiDxEdWtyIMyR67Vk5BBHPiiXHNQv/YiSPenE/Emlp7
         gzdGQQR6lvxZJ0JGp/ycWpBTc7Nzql40SoF10=
Message-ID: <19f34abd0808181143n6df11e16j90413c0ccae80176@mail.gmail.com>
Date: Mon, 18 Aug 2008 20:43:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David Howells" <dhowells@redhat.com>, "James Morris" <jmorris@namei.org>
Subject: =?UTF-8?Q?include/linux/security.h:_In_function_=E2=80=98securi?= =?UTF-8?Q?ty=5Fptrace=5Ftraceme=E2=80=99:_err?= =?UTF-8?Q?or:_=E2=80=98parent=E2=80=99_undeclared?=
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is this known and/or fixed?

commit b09c3e3f1710b554348c98e78fbf4a661918779a:

In file included from arch/x86/kernel/ptrace.c:19:
include/linux/security.h: In function 'security_ptrace_traceme':
include/linux/security.h:1760: error: 'parent' undeclared (first use
in this function)
include/linux/security.h:1760: error: (Each undeclared identifier is
reported only once
include/linux/security.h:1760: error: for each function it appears in.)

Was introduced by:

commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40
Author: David Howells <dhowells@redhat.com>
Date:   Thu Aug 14 11:37:28 2008 +0100

    security: Fix setting of PF_SUPERPRIV by __capable()

+static inline int security_ptrace_traceme(struct task_struct *child)
 {
-       return cap_ptrace(parent, child, mode);
+       return cap_ptrace_traceme(parent);
 }


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
