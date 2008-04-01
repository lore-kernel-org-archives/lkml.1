Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYDAULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYDAULl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbYDAULe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:11:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbYDAULd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:11:33 -0400
Date: Tue, 1 Apr 2008 17:10:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Morton <akpm@google.com>,
       Bongani Hlope <bonganilinux@mweb.co.za>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Message-ID: <20080401171051.724a9f75@gaivota>
In-Reply-To: <20080330162006.GA6048@joi>
References: <20080330162006.GA6048@joi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin

On Sun, 30 Mar 2008 18:20:49 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Hi
> 2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
> I bisected it down to:
> 
> 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b is first bad commit
> commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
> Author: Douglas Schilling Landgraf <dougsland@gmail.com>
> Date:   Thu Dec 27 22:20:58 2007 -0300
> 
>     V4L/DVB (6911): Converted bttv to use video_ioctl2
> 
>     Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 

There are three patches that are meant to fix the bugs with radio. On the tests
I did here, they worked, but the Bongani still points that the fixes didn't
solve for him.

On the tests I did here, the three patches seemed to work [1]. Maybe you could
test with those patches and post us some results.

There are three patches meant to fix several issues caused by the conversion: 

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=bdd38d9b5c6365ea004df6d8a183dd1344b4801f
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=055a6282cabd311cf010a5a83f0494558504f7d0
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=6e07ff78274752fe812a1e8bddb6013a278e62e8

Could you test please and give us some feedback?

[1] Yet, I've discovered recently that the hardware I use for testing PCI
devices is broken. Probably, my motherboard chipset is damaged, since I'm
getting intermittent bugs on several parts of the machine - even with stable
kernels - so my tests with bttv aren't conclusive.

Cheers,
Mauro
