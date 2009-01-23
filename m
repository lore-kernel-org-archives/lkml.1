Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbZAWINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbZAWINs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZAWINj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:13:39 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:9221 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZAWINj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:13:39 -0500
Message-Id: <49798A5E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 23 Jan 2009 08:14:06 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [Xen-devel] [PATCH 2/2] x86: add pte_set_flags/clear_flags
	 for pteflag manipulation
References: <4978F216.5040803@goop.org>
In-Reply-To: <4978F216.5040803@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 22.01.09 23:24 >>>
>+static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
>+{
>+	pteval_t v = native_pte_val(pte);
>+
>+	return native_make_pte(v | set);
>+}
>+
>+static inline pte_t pte_clear_flags(pte_t pte, pteval_t clear)
>+{
>+	pteval_t v = native_pte_val(pte);
>+
>+	return native_make_pte(v & ~clear);
>+}

I think a comment (or event a BUG_ON()) should be added here to make
clear that this absolutely must not be used to toggle the present bit. I
even view toggling _PAGE_PSE as dangerous this way.

And alternative would be to make these macros and #undef them (or keep
them inline functions but add destructive #define-s) after all their users.

Jan

