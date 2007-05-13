Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbXEMERR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbXEMERR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 00:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbXEMERL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 00:17:11 -0400
Received: from argus.EECS.Berkeley.EDU ([128.32.42.200]:46449 "EHLO
	EECS.Berkeley.EDU" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755998AbXEMERK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 00:17:10 -0400
X-Greylist: delayed 1091 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 00:17:09 EDT
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Remi Colinet <remi.colinet@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
X-Mailer: MH-E 8.0.3; nmh 1.1; GNU Emacs 22.0.96
In-Reply-To: <200705110047.04933.dtor@insightbb.com>
Date: Sat, 12 May 2007 20:58:50 -0700
Message-ID: <4010.1179028730@argus.EECS.Berkeley.EDU>
From: Jason Riedy <ejr@EECS.Berkeley.EDU>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And Dmitry Torokhov writes:
> Have you tried any other -mm? Also, does it help if you stick
>         ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> at the very beginning of psmouse_initialize() in
> drivers/input/mouse/psmouse-base.c?

Seems to fix it for me on a D620.

Bisecting on mainline gave commit
f42649e84831efc69d5f621f1c36a39b4e384a99 (Input: ALPS - handle
errors from input_register_device()) as the place where the
trackpoint half stopped working.  I don't necessarily believe it,
unless the psmouse_reset on failure caused problems without
logging anything.

Jason
