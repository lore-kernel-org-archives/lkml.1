Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZAMGQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZAMGQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbZAMGMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:12:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41664
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759519AbZAMGMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:12:23 -0500
Date: Mon, 12 Jan 2009 22:12:24 -0800 (PST)
Message-Id: <20090112.221224.170349434.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: paulus@samba.org, akpm@linux-foundation.org, jchapman@katalix.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ppp_generic - fix broken userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090111114553.GA19261@localhost>
References: <20090110.233503.222465267.davem@davemloft.net>
	<18793.51741.28374.460500@cargo.ozlabs.ibm.com>
	<20090111114553.GA19261@localhost>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Sun, 11 Jan 2009 14:45:53 +0300

> David, if you pick this patch could you rename
> the subject then as Paul proposed? Or I should
> resend the patch with new title?

Done, here is the commit message I used:

    net: ppp_generic - fix regressions caused by IDR conversion
    
    The commits:
    
    	7a95d267fb62cd6b80ef73be0592bbbe1dbd5df7
    	("net: ppp_generic - use idr technique instead of cardmaps")
    
    	ab5024ab23b78c86a0a1425defcdde48710fe449
    	("net: ppp_generic - use DEFINE_IDR for static initialization")
    
    introduced usage of IDR functionality but broke userspace side.
    
    Before this commits it was possible to allocate new ppp interface with
    specified number. Now it fails with EINVAL.  Fix it by trying to
    allocate interface with specified unit number and return EEXIST if
    fail which allow pppd to ask us to allocate new unit number.
    
    And fix messages on memory allocation fails - add details that it's
    PPP module who is complaining.
    
    Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>
