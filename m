Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYEPO0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYEPO0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYEPO0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:26:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43553 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYEPO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:26:45 -0400
Date: Fri, 16 May 2008 16:26:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: "LM Sensors" <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: Bad value with w83627thf
Message-ID: <20080516162634.26207258@hyperion.delvare>
In-Reply-To: <6101e8c40805160645x5982d5ads61a422f5600f7507@mail.gmail.com>
References: <6101e8c40805160559i4eb94ba7y7cbfea9c3f528821@mail.gmail.com>
	<20080516152712.629606bf@hyperion.delvare>
	<6101e8c40805160645x5982d5ads61a422f5600f7507@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Fri, 16 May 2008 15:45:01 +0200, Oliver Pinter wrote:
> the battery is CR2032, and it is 3V, im older kernel alway reported
> bad value 0,02V or 2,4V (i think it is a possible value), after i
> inserted new battery, show 2,4V.
> from the 2.6.26-rcX kernel showed the 3+ V. when i reboot to older
> kernel, the this state remained, but when turned off the pc, then not.

This can be easily explained. In kernel 2.6.25, we fixed a bug where
the w83627hf driver assumed that the BIOS had enabled VBat monitoring
[1]. With previous kernels, the VBat value would be wrong if the BIOS
did not actually enable VBat monitoring. Since kernel 2.6.25, the
w83627hf driver doesn't assume anything from the BIOS as far as VBat is
concerned, and enables monitoring if needed.

When you reboot your machine, the W83627THF device is not reset, so the
configuration steps done by the w83627hf driver of kernel 2.6.25+
remain. However, if you stop the machine then start it again, the
configuration is lost.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ef878b11ba245d14b7db7816217a825d6a894182

-- 
Jean Delvare
