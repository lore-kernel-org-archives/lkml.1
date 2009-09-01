Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbZIAWKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbZIAWKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZIAWKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:10:03 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63023 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbZIAWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DEhsxhuvhnSsm5isroS9QDutTfPFzi/GA7wF4S/lUIydwq4n9Xd9zUTxMxF0gxkAWW
         PmO1CYqoc4HUJhmhfSvcVCUjShBczBevEf7v1XxTkkG8cMPf3E8j7aoQ7HuZwr9czY5X
         BFoafQs0bUAkCb5eTIoJl9apKwiJ9NkKy3LBg=
MIME-Version: 1.0
In-Reply-To: <63386a3d0909011505oed88151i95df1e97cf131c36@mail.gmail.com>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
	 <1251722641.4254.46.camel@finisterre.sirena.org.uk>
	 <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
	 <20090901135123.GS19719@n2100.arm.linux.org.uk>
	 <63386a3d0909011505oed88151i95df1e97cf131c36@mail.gmail.com>
Date: Wed, 2 Sep 2009 00:10:03 +0200
Message-ID: <63386a3d0909011510s42c5fc38j753aa0219f678d3a@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/2 Linus Walleij <linus.ml.walleij@gmail.com>:

[SIGKILL]
> In the general sense perhaps this doesn't happen so much,
> what we've seen is system shut down, here some code get
> interrupted by signals, so atleast the shut down path should be
> protected I guess, I will do that in the U300 board setup
> pm_poweroff() hook then, which calls down the
> regulator/ab3100/i2c chain so all that is secured.

Or rather, I already do (I forgot about adding in that code!)

+ */
+void u300_pm_poweroff(void)
+{
+       sigset_t old, all;
+
+       sigfillset(&all);
+       if (!sigprocmask(SIG_BLOCK, &all, &old)) {
+               /* Disable LDO D to shut down the system */
+               if (main_power_15)
+                       regulator_disable(main_power_15);
+               else
+                       pr_err("regulator not available to shut down system\n");
+               (void) sigprocmask(SIG_SETMASK, &old, NULL);
+       }
+       return;
+}

Linus Walleij
