Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXKZQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXKZQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXKZQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:28:10 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45071 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbXKZQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:28:09 -0500
Date: Mon, 26 Nov 2007 10:28:03 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: akpm@osdl.org, torvalds@osdl.org, Andrew Morgan <morgan@kernel.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] -mm (2.6.24-rc3-mm1) Smack using capabilities 32 and 33
Message-ID: <20071126162803.GA3541@sergelap.austin.ibm.com>
References: <47490DE2.4030608@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47490DE2.4030608@schaufler-ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> This patch takes advantage of the increase in capability bits
> to allocate capabilities for Mandatory Access Control. Whereas
> Smack was overloading a previously allocated capability it is
> now using a pair, one for overriding access control checks and
> the other for changes to the MAC configuration.
> 
> The two capabilities allocated should be obvious in their intent.
> The comments in capability.h are intended to make it clear that
> there is no intention that implementations of MAC LSM modules
> be any more constrained by the presence of these capabilities
> than an implementation of DAC LSM modules are by the analogous
> DAC capabilities.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> ---
> 
> The companion patch for libcap-2.02 is provided as an attachment.
> The attachment is not a kernel patch, although it would be easy to
> mistake it for one.
> 
> Thank you.
> 
>  include/linux/capability.h |   20 +++++++++++++++++++-
>  security/smack/smack.h     |    8 --------
>  security/smack/smack_lsm.c |    8 ++++----
>  security/smack/smackfs.c   |   12 ++++++------
>  4 files changed, 29 insertions(+), 19 deletions(-)
> 
> diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff linux-2.6.24-rc3-mm1-base/include/linux/capability.h linux-2.6.24-rc3-mm1-smack/include/linux/capability.h
> --- linux-2.6.24-rc3-mm1-base/include/linux/capability.h	2007-11-22 01:51:36.000000000 -0800
> +++ linux-2.6.24-rc3-mm1-smack/include/linux/capability.h	2007-11-24 11:26:51.000000000 -0800
> @@ -314,6 +314,23 @@ typedef struct kernel_cap_struct {
> 
>  #define CAP_SETFCAP	     31
> 
> +/* Override MAC access.
> +   The base kernel enforces no MAC policy.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based overrides of that policy, this is
> +   the capability it should use to do so. */
> +
> +#define CAP_MAC_OVERRIDE     32
> +
> +/* Allow MAC configuration or state changes.
> +   The base kernel requires no MAC configuration.
> +   An LSM may enforce a MAC policy, and if it does and it chooses
> +   to implement capability based checks on modifications to that
> +   policy or the data required to maintain it, this is the
> +   capability it should use to do so. */
> +
> +#define CAP_MAC_ADMIN        33
> +

I do like the descriptions.

(Will wait for Andrew's comments to be addressed before reviewing the
rest)

thanks,
-serge
