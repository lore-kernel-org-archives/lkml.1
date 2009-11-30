Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZK3Fu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZK3Fu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 00:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZK3Fu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 00:50:58 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:63629 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZK3Fu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 00:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=muRNYzZ3IXnTV5BsdD3InQasHwZENvX4+xI4SFJwcBIGHnBDI2nE41EUNSsaQrDECz
         GmmOGeoS+o5rcXwi5iHgcXGXLOx1ti9933JImoB4B4sgqnw84lCHlMhWzPp297iPFYUM
         h0MuvBm3lCeYy9yy2XO6V0f49weReT9CvD4uY=
MIME-Version: 1.0
In-Reply-To: <20091130164415.f418834b.sfr@canb.auug.org.au>
References: <20091130164415.f418834b.sfr@canb.auug.org.au>
Date: Mon, 30 Nov 2009 13:51:03 +0800
Message-ID: <2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 1:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Eric,
>
> Today's linux-next merge of the sysctl tree got a conflict in
> net/sctp/sysctl.c between commit 90f2f5318b3a5b0898fef0fec9b91376c7de7a2c
> ("sctp: Update SWS avaoidance receiver side algorithm") from the net tree
> and commit f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl net: Remove
> unused binary sysctl code") from the sysctl tree.
>
> I fixed it up (see below) and can carry the fix as necessary.  I also
> removed the strategy member from the new added ctl_table entry.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc net/sctp/sysctl.c
> index ae03ded,d50a042..0000000
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@@ -285,19 -241,7 +242,17 @@@ static ctl_table sctp_table[] =
>                .extra1         = &zero,
>                .extra2         = &addr_scope_max,
>        },
>  +      {
> -               .ctl_name       = CTL_UNNUMBERED,
>  +              .procname       = "rwnd_update_shift",
>  +              .data           = &sctp_rwnd_upd_shift,
>  +              .maxlen         = sizeof(int),
>  +              .mode           = 0644,
> -               .proc_handler   = &proc_dointvec_minmax,
> -               .strategy       = &sysctl_intvec,
> ++              .proc_handler   = proc_dointvec_minmax,

Hey, what's this??
