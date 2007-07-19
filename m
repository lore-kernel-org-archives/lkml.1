Return-Path: <linux-kernel-owner+w=401wt.eu-S937214AbXGSNi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937214AbXGSNi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbXGSNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:38:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:42664 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbXGSNis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:38:48 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org>
	<alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 19 Jul 2007 15:38:46 +0200
In-Reply-To: <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org> (Linus Torvalds's message of "Wed, 18 Jul 2007 18:37:53 -0700 (PDT)")
Message-ID: <m3vecgbjix.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> So let's make a new rule:
>
>   We absolutely NEVER add things like "must_check" unless not checking 
>   causes a real and obvious SECURITY ISSUE.

Oh, come on, almost every kernel bug is a potential security issue.

IMHO, if the function can only fail due to a kernel bug, it should
return void and, in case of bug, explode with BUG_ON() or something
like that. Sure, must_check doesn't apply too well to void.

But, if I have functions which can fail for legitimate (not kernel
bug) reasons, and I know ignoring their return values would always
be a bug, then must_check seems an obvious best and simple defense
against that.
-- 
Krzysztof Halasa
