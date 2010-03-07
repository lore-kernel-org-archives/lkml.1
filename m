Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0CGPRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 10:17:00 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:34737 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab0CGPQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 10:16:58 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFtQk0tbstZK/2dsb2JhbACbQ3S3Yg2EawQ
Date: Sun, 7 Mar 2010 16:16:56 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-kernel@vger.kernel.org, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't stop on shutdown with nowayout
Message-ID: <20100307151656.GX7459@infomag.iguana.be>
References: <20100223164019.60a6de1a@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223164019.60a6de1a@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Currently, the watchdog is turned off when the system shuts down or the
> module is unloaded. If nowayout has been selected, this makes no sense
> and fails to restart the system if it hangs during reboot, so make it
> conditional.

the nowayout option is there to make sure that the watchdog keeps running
as long as the system is running. If you however do a system shutdown (which
means that you are going to reboot your server in a controlled fasion and thus
not as result of a crash or hang-situation), then either the shutdown function
of your platform_driver or the reboot_notifier call will be executed.
In the case of a watchdog device idriver we will then stop the watchdog to
prevent reboot's during the fsck that might happen after reboot.
If you run into a reboot operation during an fsck then chances a very big that
after the reboot your system will again be rebooted during the next fsck.
To prevent this fsck-reboot-loop issue we turn of the watchdog when rebooting.

Because of this, I'm not going to apply this patch.

> We have a system which has such a hang, and therefore want the watchdog
> to be on until the bitter end.

Hmm, the correct question here should be: why do we have a hang in a clean boot.
Do you have more info on what exactly happens? This might be an initialization problem.

If we better understand what happens, then we might consider having an option to keep
the watchdog on after a reboot (which has nothing to do with the nowayout functionality imho).
or even power-on.

Kind regards,
Wim.

