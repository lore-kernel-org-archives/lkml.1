Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZJFKYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZJFKYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZJFKYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:24:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32226 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbZJFKYf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Tue, 6 Oct 2009 06:24:35 -0400
Message-Id: <4ACB36DA02000078000182DD@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 06 Oct 2009 11:23:54 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Xen-devel" <xen-devel@lists.xensource.com>
Cc: "Keir Fraser" <keir.fraser@eu.citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Dan Magenheimer" <dan.magenheimer@oracle.com>,
       <kurt.hackel@oracle.com>, "Zach Brown" <zach.brown@oracle.com>,
       "Avi Kivity" <avi@redhat.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/5] x86/fixmap: add a predicate for
	 usermode fixmaps
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
 <1254790211-15416-5-git-send-email-jeremy.fitzhardinge@citrix.com>
In-Reply-To: <1254790211-15416-5-git-send-email-jeremy.fitzhardinge@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> 06.10.09 02:50 >>>
>--- a/arch/x86/include/asm/fixmap.h
>+++ b/arch/x86/include/asm/fixmap.h
>@@ -181,6 +181,24 @@ static inline void __set_fixmap(enum fixed_addresses idx,
> 
> extern void __this_fixmap_does_not_exist(void);
> 
>+static inline bool user_fixmap(enum fixed_addresses fixmap)
>+{
>+	switch (fixmap) {
>+#ifdef CONFIG_X86_32
>+	case FIX_HOLE ... FIX_VDSO:
>+#else
>+	case VSYSCALL_LAST_PAGE ... VSYSCALL_HPET:
>+#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
>+	case FIX_PVCLOCK_TIME_INFO:
>+#endif
>+#endif
>+		return true;
>+
>+	default:

Isn't that nested #ifdef rather meant to be successive to the 32-/64-bit
one?

Jan

