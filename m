Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZESWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZESWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZESWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:01:10 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11058 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZESWBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:01:09 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] SELinux: BUG in SELinux compat_net code
Date: Tue, 19 May 2009 18:01:06 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29-gentoo-r1; KDE/4.2.3; i686; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, selinux@tycho.nsa.gov, jmorris@namei.org,
       sds@tycho.nsa.gov, manoj.iyer@canonical.com
References: <1242769318.2763.22.camel@dhcp231-142.rdu.redhat.com> <7e0fb38c0905191453w611e1eaas45b20ce7c4030e59@mail.gmail.com>
In-Reply-To: <7e0fb38c0905191453w611e1eaas45b20ce7c4030e59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191801.07388.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009 05:53:52 pm Eric Paris wrote:
> Sometimes I'm an idiot, messed up TWO e-mail addresses....   stable
> and selinux, so I'm hitting both of those lists with this reply...

... and I fell for it too when ack'ing the patch.  I may write buggy code but 
at least I submit it to the write addresses ;)

Anyway, looks good to me.

Acked-by: Paul Moore <paul.moore@hp.com>

> On Tue, May 19, 2009 at 5:41 PM, Eric Paris <eparis@redhat.com> wrote:
> > This patch is not applicable to Linus's tree as the code in question has
> > been removed for 2.6.30.  I'm sending in case any of the stable
> > maintainers would like to push to their branches (which I think anything
> > pre 2.6.30 would like to do).
> >
> > Ubuntu users were experiencing a kernel panic when they enabled SELinux
> > due to an old bug in our handling of the compatibility mode network
> > controls, introduced Jan 1 2008 effad8df44261031a882e1a895415f7186a5098e
> > Most distros have not used the compat_net code since the new code was
> > introduced and so noone has hit this problem before.  Ubuntu is the only
> > distro I know that enabled that legacy cruft by default.  But, I was ask
> > to look at it and found that the above patch changed a call to
> > avc_has_perm from if(send_perm) to if(!send_perm) in
> > selinux_ip_postroute_iptables_compat().  The result is that users who
> > turn on SELinux and have compat_net set can (and oftern will) BUG() in
> > avc_has_perm_noaudit since they are requesting 0 permissions.
> >
> > This patch corrects that accidental bug introduction.
> >
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> >
> > ---
> >
> >  security/selinux/hooks.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff -up linux-source-2.6.28/security/selinux/hooks.c.pre.send
> > linux-source-2.6.28/security/selinux/hooks.c ---
> > linux-source-2.6.28/security/selinux/hooks.c.pre.send       2009-05-18
> > 13:23:16.043632602 -0400 +++ linux-source-2.6.28/security/selinux/hooks.c
> >        2009-05-18 13:23:27.899632772 -0400 @@ -4561,7 +4561,7 @@ static
> > int selinux_ip_postroute_iptables
> >        if (err)
> >                return err;
> >
> > -       if (send_perm != 0)
> > +       if (!send_perm)
> >                return 0;
> >
> >        err = sel_netport_sid(sk->sk_protocol,
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

-- 
paul moore
linux @ hp

