Return-Path: <linux-kernel-owner+w=401wt.eu-S936974AbYGCHPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936974AbYGCHPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYGCG7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:59:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:41623 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbYGCGrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:47:55 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1215063236.21182.85.camel@pasglop>
References: <200806162124.43005.bzolnier@gmail.com>
	 <200806261051.34733.bzolnier@gmail.com> <1214470868.8011.455.camel@pasglop>
	 <200806261140.39531.bzolnier@gmail.com> <1215063236.21182.85.camel@pasglop>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:47:47 +1000
Message-Id: <1215067667.21182.98.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Took me a while, kid was sick.
> 
> They apply on 20080625 (with various offset/fuzz but they do apply) and
> the tree builds. The media bay however fails the same way as before with
> IDE register errors.
> 
> I'll see if I can find where they come from.

Found multiple issues related to the ide-pmac <-> mediabay & ide core
interaction changes. I've done some fixes but it's not quite there yet.
It looks like it's getting IRQ issues with the mediabay CD, for some
reasons looks like something unmasks the interrupt before there's a
handler or around those lines... I get an irq "nobody cared" error, it
gets disabled, and then hdc gets lost interrupts.

I'll dig a bit more and if I can't find what's up tonight, will send
you my current patches in case you have some other idea.

Cheers,
Ben.


