Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXLNOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXLNOYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLNOYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:24:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXLNOYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:24:16 -0500
Date: Fri, 14 Dec 2007 15:23:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "David P. Reed" <dpreed@reed.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071214142355.GA10130@elte.hu>
References: <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <476250D5.8000409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476250D5.8000409@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> --- a/init/main.c
> +++ b/init/main.c
> @@ -229,10 +229,9 @@ static int __init obsolete_checksetup(char *line)
>  }
>
>  /*
> - * This should be approx 2 Bo*oMips to start (note initial shift), and will
> - * still work even if initially too large, it will just take slightly longer
> + * Initial value roughly corresponds to a 1 GHz CPU
>   */
> -unsigned long loops_per_jiffy = (1<<12);
> +unsigned long loops_per_jiffy = 1000000000 / HZ;
>
>  EXPORT_SYMBOL(loops_per_jiffy);

this is a factor of ~2400 increase - this will take an eternity to boot 
on any older CPU.

	Ingo
