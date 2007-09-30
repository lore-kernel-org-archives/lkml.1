Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXI3P0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXI3P0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXI3P00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:26:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33677 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXI3P0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:26:25 -0400
Date: Sun, 30 Sep 2007 17:26:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
	v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20070930152621.GB24077@elte.hu>
References: <20070926111357.GA10655@elte.hu> <20070928222631.25504d68@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070928222631.25504d68@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alejandro Riveira Fernández <ariveira@gmail.com> wrote:

> > Even if CFS v20.5 worked well for you, please try this release too, with 
> > a good focus on interactivity testing - because, unless some major 
> > showstopper is found, this codebase is intended for a v2.6.24 upstream 
> > merge.
> > 
> > ( Even a quick, subjective report of: "checked this patch, it didnt
> >   crash and it feels like v20.5" or "laggier than v20.5" or "feels 
> >   better than v20.5" is useful to us and enables us to judge the general 
> >   direction of interactivity. )
> 
>  I feel it better than 20.5 but the later is more stable. Let me 
>  explain.
> 
>  I patched a 2.6.22.9 kernel with both versions 22 and 20.5[1]. With 
>  the 22 version if i lock the screen (run screensaver) or i try to run 
>  a wine program i experience a hard lock up no keyboard or mouse and i 
>  have to reboot the machine (i can not try to access it via ssh 
>  because i do not have a second machine). I run with the nvidia kernel 
>  module so I know my report is useless but just for the record... Here 
>  it is my config:

hm. There are no similar reports so far. Could you try to run the wine 
program from a VGA text console (first do 'xhost +' in an xterm under X 
and then 'export DISPLAY=:0' in the text console) and see whether 
anything gets output to that console? Also enable nmi_watchdog=2 - which 
could print a backtrace of the point of the hard lockup.

but in general there's nothing scheduler-specific about screensavers or 
wine - but it could be related to 3D mode of the chip (hence related to 
the nvidia module) - do you get a similar lockup if you try to run 
'glxgears'?

	Ingo
