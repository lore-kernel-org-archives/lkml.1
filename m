Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZLIJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZLIJlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZLIJlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:41:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49955
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbZLIJlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:41:44 -0500
Date: Wed, 09 Dec 2009 01:41:51 -0800 (PST)
Message-Id: <20091209.014151.140337246.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: u.kleine-koenig@pengutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH] irq: handle irq0 special only on x86
From: David Miller <davem@davemloft.net>
In-Reply-To: <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Américo Wang <xiyou.wangcong@gmail.com>
Date: Wed, 9 Dec 2009 17:28:09 +0800

> 2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> I just noticed this when digging in the irq handling. ,A At least for arm
>> this doesn't make sense. ,A Not sure if x86 is the only arch this test
>> is valid for, but probably it is.
> 
> No, it is not.
> 
> Try grep -Inr 'irq0' arch/*/kernel.

The edict was sent down long ago that IRQ number zero is
special across the entire kernel tree.

If IRQ zero can happen, you should offset the IRQ values you publish
to the rest of the kernel, and translate them back when you process
them internally.
