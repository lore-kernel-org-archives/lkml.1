Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYKFOVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYKFOVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYKFOVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:21:13 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51431 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbYKFOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:21:13 -0500
X-Sasl-enc: lWuxxyInemX9IzEut4M+EJxLEgt2S/tfgqSKikzErTo6 1225981271
Date: Thu, 6 Nov 2008 12:21:07 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106142107.GC23278@khazad-dum.debian.net>
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61> <20081106082314.GA18430@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106082314.GA18430@x61>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008, Tino Keitel wrote:
> The whole fan level stuff looks a bit complicated to me. Especially the

It is.  The sysfs hwmon interface does not map 1:1 with the three possible
thinkpad fan control interfaces.  fan_control_desired_level is used for that
interface mainly, since I have to remember the last state used that was in
the set of 0-7, ignoring AUTO (which is a separate pwm control mode for
hwmon) and full-speed (which is a separate pwm control mode for hwmon).

It is hijacked by fan_suspend/fan_resume to store state between
sleep/resume, because that was convenient.  Too bad I failed to notice it
would not work properly for that.

> The attached patch tries to simplify this a bit. It sets

NAK, it would break a lot of stuff.   See my previous reply on this thread
for *some* of the stuff it would break.

I will have a proper patch out probably within 24h but most certainly before
next Monday.

Meanwhile, I suggest you just remove the calls to fan_suspend and fan_resume
as a workaround.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
