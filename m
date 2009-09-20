Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZITSaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZITSaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZITSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:30:20 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41858 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZITSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:30:17 -0400
Date: Sun, 20 Sep 2009 20:30:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Russell King <linux@arm.linux.org.uk>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] arm, cris, mips, sparc, powerpc, um, xtensa: fix build
	with bash 4.0
Message-ID: <20090920183018.GA26958@merkur.ravnborg.org>
References: <20090919145157.GA26137@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919145157.GA26137@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -10,7 +10,16 @@ PHDRS {
>  	text PT_LOAD FLAGS(7);	/* RWX */
>  	note PT_NOTE FLAGS(4);	/* R__ */
>  }
> -jiffies = JIFFIES;
> +
> +ifdef CONFIG_32BIT
> +	ifdef CONFIG_CPU_LITTLE_ENDIAN
> +		jiffies  = jiffies_64
> +	else
> +		jiffies  = jiffies_64 + 4
> +	endif
> +else
> +	jiffies  = jiffies_64
> +endif

This part miss ';' to terminate the assignment.
I already added this in my local patch but it was
accidently not included in the commit.

	Sam
