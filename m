Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXLSML0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXLSML0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 07:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbXLSMLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 07:11:16 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:50699 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbXLSMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:11:15 -0500
To: lkml@astralstorm.puszkin.org, a1426z@gawab.com
Cc: indan@nul.nu, david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <47650A4C.4000708@davidnewall.com>
	<200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
	<54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
	<200712171605.31084.a1426z@gawab.com>
	<20071218162228.79f75395@astralstorm.puszkin.org>
In-Reply-To: <20071218162228.79f75395@astralstorm.puszkin.org>
Message-Id: <200712192111.DDC12949.HFOtMOOSVLQFFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 19 Dec 2007 21:11:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Radoslaw Szkodzinski (AstralStorm) wrote:
> Actually, who needs to create device nodes? Just prohibit everyone from
> creating them, except "installer" and "udev" personality.
> This means removing CAP_MKNOD on a global scale.

What happens if the root tampers udev's configuration file?
The udev will create inappropriate (i.e. filename with unexpected attributes)
device nodes, won't it?

Also, creating device nodes is not the only threat.
The root can do
# mv /dev/sda1 /dev/tmp; mv /dev/sda2 /dev/sda1; mv /dev/tmp /dev/sda2
to rename/unlink device nodes.

After all, revoking CAP_MKNOD is not enough for guaranteeing
filename and its attributes.

This filesystem is designed to guarantee filename and its attributes,
but this filesystem has additional access control capability.
You can forbid mknod/unlink /dev/null if you want nobody to do so.
You can forbid chmod/chown /dev/null if you want nobody to do so.

Well... it is not fair to refer only udev's configuration file.
If configuration file of this filesystem is tampered,
this filesystem will create inappropriate device nodes.
So, some access control mechanism for protecting configuration files
is recommended for both udev and this filesystem.

Regards.
