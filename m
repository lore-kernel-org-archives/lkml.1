Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZKQJRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZKQJRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZKQJRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:17:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54930 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZKQJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:17:46 -0500
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Octavian Purdila <opurdila@ixiacom.com>,
       Cosmin Ratiu <cratiu@ixiacom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
References: <20091117190401.94f6b5cb.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 01:17:47 -0800
In-Reply-To: <20091117190401.94f6b5cb.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Tue\, 17 Nov 2009 19\:04\:01 +1100")
Message-ID: <m17htph5ms.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Today's linux-next merge of the sysctl tree got a conflict in
> net/ipv6/addrconf.c between commit
> f7734fdf61ec6bb848e0bafc1fb8bad2c124bb50 ("make TLLAO option for NA
> packets configurable") from the net tree and commit
> f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl net: Remove unused
> binary sysctl code") from the sysctl tree.
>
> I fixed it up (see below) including removing the new ctl_name (thanks for
> the heads up, Eric).   I can carry this fixup as necessary.

Would it be of any value for me to send David a change killing ctl_name
for the new entry?  That is equivalent to .ctl_name = CTL_UNNUMBERED and
would make this a trivial conflict.

Fundamentally the conflict detection will always kick in here because
as I am modifying previous and succeeding entries in the table so the
context will always be different.

I'm still getting a hang of running a public git tree.

Eric

> diff --cc net/ipv6/addrconf.c
> index 522bdc7,f918399..0000000
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@@ -4388,15 -4285,7 +4320,14 @@@ static struct addrconf_sysctl_tabl
>   			.proc_handler	=	proc_dointvec,
>   		},
>   		{
> - 			.ctl_name       = CTL_UNNUMBERED,
>  +			.procname       = "force_tllao",
>  +			.data           = &ipv6_devconf.force_tllao,
>  +			.maxlen         = sizeof(int),
>  +			.mode           = 0644,
>  +			.proc_handler   = proc_dointvec
>  +		},
>  +		{
> - 			.ctl_name	=	0,	/* sentinel */
> + 			/* sentinel */
>   		}
>   	},
>   };
