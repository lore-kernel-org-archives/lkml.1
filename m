Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZFXKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZFXKjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFXKjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:39:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60730
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbZFXKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:39:05 -0400
Date: Wed, 24 Jun 2009 03:39:09 -0700 (PDT)
Message-Id: <20090624.033909.147195176.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special
 ide-{floppy,tape} driver requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906241209.53891.bzolnier@gmail.com>
References: <200906232326.06830.bzolnier@gmail.com>
	<20090623.234929.32348223.davem@davemloft.net>
	<200906241209.53891.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 24 Jun 2009 12:09:53 +0200

> The obscure reasons is just the fact that both ide-floppy and ide-tape
> had a they own duplicated/buggy request completion routines.
> 
> While they were being unified the whole bunch of similar class of bugs
> were fixed so I agree that there may still be more issues to deal with
> there.

I see, the ->pc_callback() of these things set rq->errors and then
ide_pc_intr() happily overrides whatever was set there, either on it's
own or via ide_complete_rq().

I'll look over this some more while I wait for the testing results
from Borislav.
