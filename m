Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYBJRsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYBJRsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYBJRsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:48:32 -0500
Received: from rfc2324.org ([89.149.194.216]:39814 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYBJRsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:48:31 -0500
Date: Sun, 10 Feb 2008 18:48:08 +0100
From: Maximilian Wilhelm <max@rfc2324.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Maximilian Wilhelm <max@rfc2324.org>, linux-kernel@vger.kernel.org,
       Eric.Moore@lsi.com
Subject: Re: Kernel Panic in MPT SAS on 2.6.24 (and 2.6.23.14, 2.6.23.9)
Message-ID: <20080210174807.GB20450@outback.rfc2324.org>
Mail-Followup-To: Krzysztof Oledzki <olel@ans.pl>,
	Maximilian Wilhelm <max@rfc2324.org>, linux-kernel@vger.kernel.org,
	Eric.Moore@lsi.com
References: <20080206210426.GD11236@outback.rfc2324.org> <47AB82DD.90201@ans.pl> <20080208012028.GF11236@outback.rfc2324.org> <20080208014805.GG11236@outback.rfc2324.org> <20080210024633.GA20450@outback.rfc2324.org> <Pine.LNX.4.64.0802101823020.22894@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802101823020.22894@bizon.gios.gov.pl>
X-Operating-System: Linux 2.6.23.9-grsec auf i686
X-Warning: This message may contain ironic / sarcastic elements.
X-GC-3.12: GCM/CS/IT d+(--) s+: a-- C++>$ UL++++$ US>++++ P++ L+++>++++ E--- W+ N o+ K- w O? M? V? PS+ PE Y+ PGP++ t 5? X- R tv b+(++) DI+(++) !D G++ e>+++  h!>--(---) r++ y+
X-message-Flag: Outlook: A programm to spread viri, but it can mail, too.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sunday, den 10 February hub Krzysztof Oledzki folgendes in die Tasten:

> >I did a git bisect between v2.6.22 v2.6.23 and it seems that
> > 6cb8f91320d3e720351c21741da795fed580b21b
> >introduced some badness.

> Thanks! This was *really* useful!

> Now, how about attached patch? Should work with both 2.6.23 and 2.6.24.

I build a patched 2.6.24 and it bootet without a problem.

> [SCSI] mpt fusion: Don't oops if NumPhys==0

> Don't oops if NumPhys==0, instead return -ENODEV.
> This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9909
 
> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Tested-by: Maximilian Wilhelm <max@rfc2324.org>

> diff -Nur a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> --- a/drivers/message/fusion/mptsas.c	2007-10-09 22:31:38.000000000 +0200
> +++ b/drivers/message/fusion/mptsas.c	2008-02-10 17:38:51.000000000 +0100
> @@ -1772,6 +1772,11 @@
>  	if (error)
>  		goto out_free_consistent;
>  
> +	if (!buffer->NumPhys) {
> +		error = -ENODEV;
> +		goto out_free_consistent;
> +	}
> +
>  	/* save config data */
>  	port_info->num_phys = buffer->NumPhys;
>  	port_info->phy_info = kcalloc(port_info->num_phys,

Many Thanks!

Ciao
Max
-- 
	Follow the white penguin.
