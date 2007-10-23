Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXJWKBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXJWKBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXJWKB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:01:28 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:12966
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbXJWKB1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:01:27 -0400
Message-Id: <471DE2F8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 23 Oct 2007 11:03:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@xensource.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: CONFIG_XEN dependencies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,

CONFIG_XEN (in 2.6.23) depends on X86_CMPXCHG and X86_TSC. This
precludes enabling the option in kernels using M386, M486, or M586, despite
the fact that the detection code doesn't need these features and if Xen is
present the features are implicitly there. At least the X86_TSC dependency
can thus be dropped in my opinion, which would then only exclude M386
kernels. (Dropping X86_CMPXCHG may yield build problems, but could
perhaps also be eliminated by forcibly #define-ing it in the relevant source
files.)

Jan

