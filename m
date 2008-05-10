Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYEJWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYEJWxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYEJWxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 18:53:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44380 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbYEJWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 18:53:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 May 2008 00:53:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Hack to fix not working spindown over Firewire
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Tino Keitel <tino.keitel@gmx.de>
In-Reply-To: <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
Message-ID: <tkrat.8f92142276ccb4e5@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
 <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> 1) FireWire to IDE or to SATA chipset
> 2) start bit is honored:
>    "sg_start --stop" stops the motor and "sg_start" restarts it
> 3) power condition field is honored:
>    "sg_start --pc=3" stops the motor and "sg_start --pc=1 restarts it
> 4) peripheral device type claimed by the firmware
> 5) vendor and model of the enclosure
> 
> 
> 1)           2)     3)     4)    5)
> bridge       start  pc     PDT   enclosure
> --------------------------------------------------------------
...
> TSB42AA9     no     yes    SBC   DViCO MomoBay CX-1
> TSB42AA9A    yes    yes    RBC   DViCO MomoBay FX-3A

Correction:  While the FX-3A stops the motor if START STOP UNIT with an
equivalent to "sg_start --stop", it does not work correctly anymore
after it.  Certain commands after that will hang the firmware up;
notably those sent when sd_mod is probing the disk.  I.e. FX-3A fails
not exactly as CX-1, but similarly.
-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/

