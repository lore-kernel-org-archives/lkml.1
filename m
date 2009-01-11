Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZAKJxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZAKJxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZAKJw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:52:57 -0500
Received: from newton.gmurray.org.uk ([81.2.114.237]:40982 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZAKJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:52:55 -0500
X-Greylist: delayed 1416 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 04:52:55 EST
X-DKIM: Sendmail DKIM Filter v2.8.0.Beta7 newton.gmurray.org.uk n0B9THFN002939
From: Graham Murray <graham@gmurray.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	<1231513655.5317.30.camel@dax.rpnet.com>
X-Hashcash: 1:22:090111:linux-kernel@vger.kernel.org::y+mlpF6rcfnZ6L+A:000000000000000000000000000000000F/24
Date: Sun, 11 Jan 2009 09:29:16 +0000
In-Reply-To: <1231513655.5317.30.camel@dax.rpnet.com> (Richard Purdie's
	message of "Fri, 09 Jan 2009 15:07:35 +0000")
Message-ID: <87priu5gyb.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie <rpurdie@rpsys.net> writes:

> Hi,
>
> I just updated to the latest kernel from git to test some other patches
> and after logging into GDM the X server hangs before launching the
> desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
> (i915 graphics). Bisection shows this happens after applying this
> commit:
>
> On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
>> Please pull the 'drm-next' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
> [...]
>> commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a


I am seeing a similar, but slightly different problem which I bisected
to that same commit. I am using radeonfb and the radeon X driver and I
can log into kdm with no problems and work, but once I switch to a
'normal' console with CTL+ALT+Fn when I switch back to X it is dead with
the top, approximately 1/3, of the screen corrupted and keyboard and
mouse dead. I can get out of it by SAK+K which kills X and returns to
the kdm logon screen. There are no ooops or any other indications apart
from logging the SAK action.

06:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] (prog-if 00 [VGA controller])
        Subsystem: C.P. Technology Co. Ltd Device 2090
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        I/O ports at c800 [size=256]
        Memory at ff9f0000 (32-bit, non-prefetchable) [size=64K]
        Expansion ROM at ff9c0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: radeonfb

06:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
        Subsystem: C.P. Technology Co. Ltd Device 2091
        Flags: bus master, fast devsel, latency 0
        Memory at ff9e0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint, MSI 00
