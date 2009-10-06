Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbZJFLth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbZJFLth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbZJFLtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:49:36 -0400
Received: from ns.penguin.cz ([84.21.108.25]:36638 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbZJFLtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:49:35 -0400
Subject: Re: spitz: add gpio button support (AK_INT and remote control
	description)
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com
In-Reply-To: <20091006074635.GA2775@ucw.cz>
References: <20091006074635.GA2775@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 Oct 2009 13:48:52 +0200
Message-Id: <1254829732.3546.35.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> I'm not sure what AK_INT is, nor what event it should
> generate.

AK_INT: remote control detect

How it should work on spitz:

The default state of ﻿the remote pin of audio barrel connector is a weak
pull-up.

Button is pressed. => Voltage ﻿on remote pin decreases. => Hardware
defined threshold voltage is reached. => AK_INT is triggered. => Driver
sets SPITZ_SCP2_AKIN_PULLUP (it connects stronger and more power hungry
pull-up), ignores AK_INT change, sets MAX1111 to channel 0, reads value
from A/D converter.

After some debouncing:

The value is below threshold. => Decode the value and generate input
event.

The value is over threshold. => Switch SPITZ_SCP2_AKIN_PULLUP back,
activate AK_INT interrupt and wait for next edge.

The value is near zero. => ﻿A standard 3-ring earphone connector seems
to be inserted. AK_INT will be "active" all the time. To save stronger
pull-up power, behave like the value over threshold and ignore AK_INT
until possible next change (remove earphone, insert remote).

Some of these actions should probably cause wake-up. It would be nice to
wake-up sleeping Zaurus by pressing Play button and start to play.

The driver is available e. g. in 2.6.26-RP kernel as
sharpsl-rc-r1.patch. I plan to rewrite it to a generic "resistor matrix
keyboard" and then sent to vanilla.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

