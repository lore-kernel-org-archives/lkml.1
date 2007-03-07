Return-Path: <linux-kernel-owner+w=401wt.eu-S965740AbXCGXiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965740AbXCGXiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXCGXiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:38:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39242
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992743AbXCGXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:38:16 -0500
Date: Wed, 07 Mar 2007 15:38:13 -0800 (PST)
Message-Id: <20070307.153813.116350402.davem@davemloft.net>
To: eparis@parisplace.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jamesm@namei.org,
       vyekkirala@trustedcs.com, cxzhang@watson.ibm.com, sds@tycho.nsa.gov
Subject: Re: [PATCH] xfrm_policy delete security check misplaced
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172860190.31047.11.camel@localhost.localdomain>
References: <1172860190.31047.11.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@parisplace.org>
Date: Fri, 02 Mar 2007 13:29:50 -0500

> The security hooks to check permissions to remove an xfrm_policy were
> actually done after the policy was removed.  Since the unlinking and
> deletion are done in xfrm_policy_by* functions this moves the hooks
> inside those 2 functions.  There we have all the information needed to
> do the security check and it can be done before the deletion.  Since
> auditing requires the result of that security check err has to be passed
> back and forth from the xfrm_policy_by* functions.  
> 
> This patch also fixes a bug where a deletion that failed the security
> check could cause improper accounting on the xfrm_policy
> (xfrm_get_policy didn't have a put on the exit path for the hold taken
> by xfrm_policy_by*)
> 
> It also fixes the return code when no policy is found in
> xfrm_add_pol_expire.  In old code (at least back in the 2.6.18 days) err
> wasn't used before the return when no policy is found and so the
> initialization would cause err to be ENOENT.  But since err has since
> been used above when we don't get a policy back from the xfrm_policy_by*
> function we would always return 0 instead of the intended ENOENT.  Also
> fixed some white space damage in the same area. 
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied.
