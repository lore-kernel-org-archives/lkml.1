Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYBATY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYBATY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbYBATYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:24:14 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:56130 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594AbYBATYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:24:12 -0500
Date: Fri, 1 Feb 2008 11:24:09 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Adrian Bunk <bunk@kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m, I2C=n
 compile error
In-Reply-To: <Pine.LNX.4.64.0801281314450.1185@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0802011117120.5488@shell2.speakeasy.net>
References: <20080127185216.GB13300@does.not.exist> <20080127223334.696fce6e@gaivota>
 <20080128084001.GB1001@does.not.exist> <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
 <Pine.LNX.4.64.0801281314450.1185@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Jan Engelhardt wrote:
> On Jan 28 2008 01:05, Trent Piepho wrote:
>
> >Maybe the kernel headers should provide a couple macros for testing
> >configs, since people get it wrong over and over again?
> >
> >#define CONFIG_ON(x) (defined(CONFIG_##x) || defined(CONFIG_##x##_MODULE))
> >#define CONFIG_AVAIABLE(x) (defined(CONFIG_##x) || (defined(MODULE) && defined(CONFIG_##x##_MODULE)))
>                ^AVAILABLE(x)
>
> What's the difference between these two?
>
> CONFIG_x_MODULE will never be defined if MODULE is not, so defined(MODULE)
> seems redundant.

You're probably thinking of CONFIG_MODULES, which indicates the kernel
supports module loading.  MODULE indicates the current code is being
compiled as a module.  The idea is that code compiled in the kernel can't
call modules.  Generally what you would see is:

#if CONFIG_ON(x)
code that will be _used by_ x
probably want x to depend on us in Kconfig
#endif
#if CONFIG_AVAILABLE(x)
code that wants _to use_ x
#endif
