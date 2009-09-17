Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZIQTdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZIQTdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZIQTdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:33:21 -0400
Received: from fieldses.org ([174.143.236.118]:59695 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZIQTdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:33:20 -0400
Date: Thu, 17 Sep 2009 15:33:23 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: nfsd tree build failure
Message-ID: <20090917193323.GB3123@fieldses.org>
References: <20090917171031.128a846b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917171031.128a846b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 05:10:31PM +1000, Stephen Rothwell wrote:
> Today's linux-next build (sparc64_defconfig) failed like this:
> 
> In file included from arch/sparc/kernel/sys_sparc32.c:32:
> include/linux/nfsd/nfsd.h: In function 'nfs4_state_start':
> include/linux/nfsd/nfsd.h:177: error: no return statement in function returning non-void

Thanks for catching this!

> Caused by commit 29ab23cc5d351658d01a4327d55e9106a73fd04f ("nfsd4: allow
> nfs4 state startup to fail").  Please, if you add code that depends on a
> CONFIG option, build with that option enabled and disabled.

And, um, yes, I'll try to do better at that.

> I have applied the following patch for today:

Thanks, applied (with fixed return value).

--b.

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 17 Sep 2009 17:03:06 +1000
> Subject: [PATCH] nfsd: return success for non NFS4 nfs4_state_start
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/nfsd/nfsd.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
> index 24fdf89..e9ffeb5 100644
> --- a/include/linux/nfsd/nfsd.h
> +++ b/include/linux/nfsd/nfsd.h
> @@ -174,7 +174,7 @@ int nfs4_reset_recoverydir(char *recdir);
>  #else
>  static inline int nfs4_state_init(void) { return 0; }
>  static inline void nfsd4_free_slabs(void) { }
> -static inline int nfs4_state_start(void) { }
> +static inline int nfs4_state_start(void) { return 1; }
>  static inline void nfs4_state_shutdown(void) { }
>  static inline time_t nfs4_lease_time(void) { return 0; }
>  static inline void nfs4_reset_lease(time_t leasetime) { }
> -- 
> 1.6.3.3
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
