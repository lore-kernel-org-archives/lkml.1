Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZESVyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZESVyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZESVyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:54:39 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24581 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbZESVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:54:38 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] SELinux: BUG in SELinux compat_net code
Date: Tue, 19 May 2009 17:53:54 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29-gentoo-r1; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
       selinux@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       manoj.iyer@canonical.com
References: <1242769318.2763.22.camel@dhcp231-142.rdu.redhat.com>
In-Reply-To: <1242769318.2763.22.camel@dhcp231-142.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191753.56273.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009 05:41:58 pm Eric Paris wrote:
> This patch is not applicable to Linus's tree as the code in question has
> been removed for 2.6.30.  I'm sending in case any of the stable
> maintainers would like to push to their branches (which I think anything
> pre 2.6.30 would like to do).
>
> Ubuntu users were experiencing a kernel panic when they enabled SELinux
> due to an old bug in our handling of the compatibility mode network
> controls, introduced Jan 1 2008 effad8df44261031a882e1a895415f7186a5098e
> Most distros have not used the compat_net code since the new code was
> introduced and so noone has hit this problem before.  Ubuntu is the only
> distro I know that enabled that legacy cruft by default.  But, I was ask
> to look at it and found that the above patch changed a call to
> avc_has_perm from if(send_perm) to if(!send_perm) in
> selinux_ip_postroute_iptables_compat().  The result is that users who
> turn on SELinux and have compat_net set can (and oftern will) BUG() in
> avc_has_perm_noaudit since they are requesting 0 permissions.
>
> This patch corrects that accidental bug introduction.
>
> Signed-off-by: Eric Paris <eparis@redhat.com>

My mistake, thanks to Eric for catching and fixing this bug.

Acked-by: Paul Moore <paul.moore@hp.com>

> ---
>
>  security/selinux/hooks.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -up linux-source-2.6.28/security/selinux/hooks.c.pre.send
> linux-source-2.6.28/security/selinux/hooks.c ---
> linux-source-2.6.28/security/selinux/hooks.c.pre.send	2009-05-18
> 13:23:16.043632602 -0400 +++
> linux-source-2.6.28/security/selinux/hooks.c	2009-05-18 13:23:27.899632772
> -0400 @@ -4561,7 +4561,7 @@ static int selinux_ip_postroute_iptables
>  	if (err)
>  		return err;
>
> -	if (send_perm != 0)
> +	if (!send_perm)
>  		return 0;
>
>  	err = sel_netport_sid(sk->sk_protocol,

-- 
paul moore
linux @ hp

