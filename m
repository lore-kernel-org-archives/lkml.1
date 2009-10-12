Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbZJLRFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbZJLRFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbZJLRFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:05:37 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:62982 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbZJLRFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:05:35 -0400
Date: Tue, 13 Oct 2009 02:04:15 +0900 (JST)
Message-Id: <20091013.020415.78716977.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: andy.sharp@lsi.com, thomas.hommel@gefanuc.com, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] rtc-ds1511: Fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20091012184739.46bb1052@i1501.lan.towertech.it>
References: <1255365461-5732-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20091012184739.46bb1052@i1501.lan.towertech.it>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 18:47:39 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > * Call dev_set_drvdata before rtc device creation
> > * Use its own spinlock instead of rtc->irq_lock
> 
>  why?

Because pdata->rtc must be initialized to use the irq_lock
(pdata->rtc->irq_lock).  There is a small window which rtc methods can
be called before pdata->rtc is initialized.

And there is no need use the irq_lock to protect hardware registers.
The driver's own spinlock shoule be enough.

---
Atsushi Nemoto
