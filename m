Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbYJOSjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbYJOSjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYJOSi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:38:59 -0400
Received: from www.steve.org.uk ([80.68.85.46]:37185 "EHLO skx.xen-hosting.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYJOSi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:38:59 -0400
X-Greylist: delayed 1884 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 14:38:58 EDT
Date: Wed, 15 Oct 2008 19:07:32 +0100
From: Steve Kemp <steve@steve.org.uk>
To: linux-kernel@vger.kernel.org
Subject: trivial patches: Should we care about control reaches end of
	non-void function
Message-ID: <20081015180732.GA4119@steve.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  During my build processes I see a lot of messages like this:

  In function xxx:
 xxx.c:123: control reaches end of non-void function

  These are typically caused by constructs like:

    static int some_function()
    {
        switch (blah) {
        ...

        default:
            BUG();
        }
    }

  I see some functions in the kernel have added "return 0" after the
 BUG, presumably to silence these warnings.  Would a patch to do this
 consistently, or is that too trivial even for trivial patches?

  Actual example:
    ./mm/mempolicy.c
        policy_zonelist - gives this warning.
        slab_node       - gives this warning
        __mpol_equal    - has the warning silenced via explicit return.

Steve
-- 
Managed Anti-Spam Service
http://mail-scanning.com/

