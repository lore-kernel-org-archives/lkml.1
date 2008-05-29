Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYE2Q3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYE2Q3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYE2Q3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:29:14 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:41558 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753323AbYE2Q3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:29:13 -0400
X-YMail-OSG: _mkx8nQVM1mkNuqKGiENNDuUQGEBV2lD11.QSSl1.zzoUzhYHEWVreMPILsr.ijqst16bZbhn2ZPr_gW8R6kk4Bsc8vLfd2vRjLYkg--
X-RocketYMMF: rancidfat
Date: Thu, 29 May 2008 09:29:08 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: 2.6.24-rc4: mount.ntfs-3g hangs when smack is enabled
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       casey@schaufler-ca.com
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080529131401.7429568d@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <886653.90862.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> wrote:

> 
>  Hi Casey,
> 
>  I'm not sure whether this is a smack problem, but Mandriva users are
> reporting that mount.ntfs-3g (ntfs driver, uses FUSE) hangs when
> they try to mount their NTFS partition.
> 
>  I could reproduce the problem with a vanilla 2.6.24-rc4 kernel, and it
> only happens when Smack is enabled.

Thank you for the report. I will look into it. 

>  Besides that, I've been told that a similar problem happens with unionfs,
> but I haven't tried to reproduce it yet.
> 
>  What follows is the output of SysRq+D:
> 
> """
> Showing all locks held in the system:
> 1 lock held by mingetty/4193:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 1 lock held by mingetty/4194:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 1 lock held by mingetty/4195:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 1 lock held by mingetty/4196:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 1 lock held by mingetty/4197:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 2 locks held by mount.ntfs-3g/4667:
>  #0:  (&type->s_umount_key#19){--..}, at: [<c01726f0>] sget+0x202/0x350
>  #1:  (&isp->smk_lock){--..}, at: [<c01c7f87>] smack_d_instantiate+0x39/0x129
> 1 lock held by bash/4844:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 1 lock held by bash/5389:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> 1 lock held by bash/5498:
>  #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
> """
> 
>  Let me know if you need more information.
> 
>  Best regards.
> 
> -- 
> Luiz Fernando N. Capitulino
> 
> 


Casey Schaufler
casey@schaufler-ca.com
