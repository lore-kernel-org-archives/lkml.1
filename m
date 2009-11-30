Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZK3U2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZK3U2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZK3U2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:28:07 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:44255 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752458AbZK3U2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:28:06 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 15:28:06 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Y2kmxizkVMI49toJWLiq1HrmD+k91DDyeH71RoA5Dj6UZqUbBC7CcclVasHoMNTuSADp3mvx/agOhFLRORCH7u/8s0CmpexQMMTfrTH+s3jHSAuOm1wd54RURgl80cIwq3eeX3HbVCjpQ7j6oAopL1vfJZjO/ow8Q+MWVvx+xiM=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: NE6rNzQVM1lFNJPmT3UAkpzWzHNNTFDswQQbXjVwkG0WH2KPodAyKbw2RN9aI__zEJjU0DF87H21ZF4e_4ReyTNQdUnktKuxtw7UU8tWkXX5fX4cUNs2hjgZfJ74ZADk6xSIMOnP2XTnrbqHLyxjG7t_RJDRlOwqtTB.._PK4jGZgdMq1KzF_UXuCp6hQ3Z8viiM.aakP86C.g8cmHMPXQ0mYQ3MqQGqlkMhk1XiajH47JtiKap5lb2nqf1bJ6_l
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the right place
Date: Mon, 30 Nov 2009 12:21:30 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200911301221.30601.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 November 2009, Uwe Kleine-König wrote:
> +               if (new->flags & IRQF_DISABLED)
> +                       pr_warning("IRQ %d/%s: IRQF_DISABLED is not guaranteed "
> +                                       "on shared IRQs\n", irq, new->name);

This should have copied the original test ... this way,
it's dropping the SHARED constraint, and trying to morph
into a generic "IRQF_DISABLED is eeebil!" test.

If it just moved the original test, I'd have no problem
with the patch.


... although it'd still not address the general mess in
this area, it'd at least not introduce false warnings.
