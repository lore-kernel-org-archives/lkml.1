Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZCTHTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZCTHTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 03:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZCTHSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 03:18:55 -0400
Received: from tjworld.net ([67.18.187.6]:46460 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbZCTHSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 03:18:54 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 03:18:54 EDT
Subject: How? PM suspend resume code in misc driver?
From: TJ <linux@tjworld.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: TJworld
Date: Fri, 20 Mar 2009 07:11:52 +0000
Message-Id: <1237533112.12021.7.camel@hephaestion>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to figure out how a misc char driver (in this case
acerhk) can link into PM suspend and resume events. I found the patches
from 2008-02 that introduced a 'heavy-handed' mechanism to misc that
were quickly removed by another set of patches in 2008-04.

In the removal patches there is mention of a 'better way of doing it'
but I've not been able to locate any documentation to that end.

The precise requirement is to fix a problem for a user of a laptop that
'forgets' the state of the RF frequency kill switch during suspend. When
the PC resumes the radio is off and the hardware button has to be
manually activated.

The acerhk module is the only way to enable use of the kill-switch on
this PC.

My thought was that if acerhk can link into the PM events it can use the
resume event to re-enable the radio if it was enabled on suspend.

In this particular case it seems from the user's description that the
hardware switch is a momentary push-to-make type rather than a latching
switch that is more common.

