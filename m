Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYDAUXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYDAUXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbYDAUXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:23:39 -0400
Received: from outbound-mail-34.bluehost.com ([69.89.18.154]:47571 "HELO
	outbound-mail-34.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759887AbYDAUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:23:38 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Tue, 1 Apr 2008 13:22:58 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
References: <47D828BB.2000702@gawab.com> <200803251308.43830.jbarnes@virtuousgeek.org> <47F13A74.8010206@gawab.com>
In-Reply-To: <47F13A74.8010206@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011322.58259.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 31, 2008 12:24 pm Justin Madru wrote:
> Well, I disabled gdm and tryed to trigger the blank screen. I did about ~16
> reboots and it blanked out on me only 2 times. I was using a script to
> reboot and/or startx. One time I'm not exactly sure if X was started, so it
> might have blanked out on a "startx". The other time I'm fairly sure X
> wasn't started, so it blanked out on a terminal login.

Ok, so that might indicate something in the fb layer is killing it...

> Both of the blank outs were different than the ones with gdm started.
> Pressing ctrl+alt+f# changed nothing on the screen; the screen seemed
> almost completely off (no or little backlight). A few seconds after
> pressing the power button the shutdown splash screen would show, but this
> time it was _very_ faint.
>
> Usually, when gdm is enabled, pressing ctrl+alt+f# would "refresh" (or
> mode/resolution change) the screen, but it would still be blank. Also the
> backlight still seamed to be on and at full brightness (although, still
> displaying black).
>
> Well, I don't know what to say, it's the strangest of problems.

Yeah, seems pretty weird.  Given that you see it w/o the fb stuff loaded as 
well and we still have a few open bugs against the intel X driver regarding 
VT switch & mode programming, I don't think this is a real kernel regression.  
It's more likely that some timing or memory layout changed subtly and is 
causing to to hit one of our existing bugs more frequently that you did 
before.  Can you file a bug against the intel X driver at 
bugs.freedesktop.org so we can track it there?  Unless we can find a way to 
reproduce it reliably it'll probably take a long time to fix, but we don't 
want to lose it either...

Thanks,
Jesse
