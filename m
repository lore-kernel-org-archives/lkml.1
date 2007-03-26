Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbXCZTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbXCZTTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXCZTTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:19:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbXCZTTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:19:23 -0400
Date: Mon, 26 Mar 2007 12:17:18 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       zaitcev@redhat.com
Subject: Re: Fix sudden warps in mousedev
Message-Id: <20070326121718.3940a579.zaitcev@redhat.com>
In-Reply-To: <200703252319.39676.dtor@insightbb.com>
References: <20070324001610.724a820a.zaitcev@redhat.com>
	<200703250134.03416.dtor@insightbb.com>
	<20070325111930.f6428509.zaitcev@redhat.com>
	<200703252319.39676.dtor@insightbb.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 23:19:38 -0400, Dmitry Torokhov <dtor@insightbb.com> wrote:

> I tried to reproduce warping on console but could not for some reason. Could you
> please try the patch below and tell me if it fixes the problem for you?

> +++ work/drivers/input/mousedev.c
> @@ -124,32 +124,33 @@ static void mousedev_touchpad_event(stru
> -				if (mousedev->pkt_count >= 2) {
> +			if (mousedev->touch && mousedev->pkt_count >= 2) {

This works, thanks a lot.

The double-indented switch() is annoying, but since the whole driver
is written to the same style, I can live with it, for the uniformity
purposes :-)

You can't imagine the relief of using a reliable pointer again, after
months of touching the pad with a certain trepidation.

-- Pete
