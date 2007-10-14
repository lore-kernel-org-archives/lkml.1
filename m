Return-Path: <linux-kernel-owner+w=401wt.eu-S1763432AbXJNRxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763432AbXJNRxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760531AbXJNRvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:51:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35264 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760289AbXJNRv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:51:29 -0400
Date: Sun, 14 Oct 2007 19:51:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: tuner-core.c:fe_has_signal() can returne uninitialized value
Message-ID: <20071014175159.GO4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1f5ef19779df2c2f75870332b37dd3004c08a515 added the following 
function to drivers/media/video/tuner-core.c:

<--  snip  -->

static int fe_has_signal(struct tuner *t)
{
        struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
        u16 strength;

        if (fe_tuner_ops->get_rf_strength)
                fe_tuner_ops->get_rf_strength(&t->fe, &strength);

        return strength;
}

<--  snip  -->


If (!fe_tuner_ops->get_rf_strength) this function returns the value of 
an uninitialized variable.

Spotted by the Coverity checker.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

