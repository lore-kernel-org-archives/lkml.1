Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZI2J2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZI2J2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZI2J2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:28:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:6992 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZI2J2h convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-jbeulich@novell.com;5:2>);
	Tue, 29 Sep 2009 05:28:37 -0400
Message-Id: <4AC1E15502000078000516B5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 29 Sep 2009 10:28:36 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sfr@canb.auug.org.au>, <hollisb@us.ibm.com>
Cc: <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
       <kvm-ppc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-next@vger.kernel.org>
Subject: Re: linux-next: tree build failure
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hollis Blanchard  09/29/09 2:00 AM >>>
>First, I think there is a real bug here, and the code should read like
>this (to match the comment):
>    /* type has to be known at build time for optimization */
>-    BUILD_BUG_ON(__builtin_constant_p(type));
>+    BUILD_BUG_ON(!__builtin_constant_p(type));
>
>However, I get the same build error *both* ways, i.e.
>__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
>the new BUILD_BUG_ON() macro isn't working...

No, at this point of the compilation process it's neither zero nor one,
it's simply considered non-constant by the compiler at that stage
(this builtin is used for optimization, not during parsing, and the
error gets generated when the body of the function gets parsed,
not when code gets generated from it).

Jan

