Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYFDNlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYFDNlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYFDNl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:41:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47481 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYFDNl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:41:26 -0400
Date: Wed, 4 Jun 2008 08:41:16 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Serge Hallyn <serue@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] devcgroup: make a helper to convert
	cgroup_subsys_state to devs_cgroup
Message-ID: <20080604134116.GD16854@us.ibm.com>
References: <484645C1.6030108@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484645C1.6030108@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> This is just picking the container_of out of cgroup_to_devcgroup into
> a separate function.
> 
> This new css_to_devcgroup will be used in the 2nd patch.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Thanks, Pavel.

Acked-by: Serge Hallyn <serue@us.ibm.com>

to both, obviously.

-serge

> ---
>  security/device_cgroup.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 4ea5836..15f2f80 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -49,10 +49,14 @@ struct dev_cgroup {
>  	spinlock_t lock;
>  };
> 
> +static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
> +{
> +	return container_of(s, struct dev_cgroup, css);
> +}
> +
>  static inline struct dev_cgroup *cgroup_to_devcgroup(struct cgroup *cgroup)
>  {
> -	return container_of(cgroup_subsys_state(cgroup, devices_subsys_id),
> -			    struct dev_cgroup, css);
> +	return css_to_devcgroup(cgroup_subsys_state(cgroup, devices_subsys_id));
>  }
> 
>  struct cgroup_subsys devices_subsys;
> -- 
> 1.5.3.4
