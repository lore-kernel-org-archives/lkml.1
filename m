Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYCSTi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYCSTi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYCSTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:08 -0400
Received: from c-67-188-67-135.hsd1.ca.comcast.net ([67.188.67.135]:40048 "EHLO
	freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755132AbYCSTaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:05 -0400
Date: Wed, 19 Mar 2008 01:11:46 -0700
From: "Adam J. Richter" <adam@yggdrasil.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Adam J. Richter" <adam@yggdrasil.com>, pshou@realtek.com.tw,
       matt.jared@intel.com, andy.kopp@intel.com, dan.d.kogan@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: intel-hda sound too quiet in linux-2.6.25-rc6
Message-ID: <20080319081146.GA11524@freya.yggdrasil.com>
References: <20080318062359.GA19453@freya.yggdrasil.com> <s5hwso0nxra.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwso0nxra.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

	Thank you for your quick response.  Your suggested alsa
commands seem to have worked.  Here is a more detailed response in
case the information contained below might be helpful.


On Tue, Mar 18, 2008 at 11:15:53AM +0100, Takashi Iwai wrote:
[...] 
> This is likely a missing volume setting.  With the upgrade to 2.6.25,
> you may have a different mixer representation and the udev or init
> script didn't restore the old mixer setting properly (typicall missing
> -F option to alsactl).  Also note that aumix doesn't cover all volume
> controls since it's an OSS app.

	I would think that these new volume controls should be made to
default to whatever setting leaves the volume unmodified (usually
"100%"), to minimize disruption and to preserve support for pure OSS
systems.  I would be interested to know if there is some consideration
that outweighs this.

> Anyway, there is too little hardware information here.  Please show
> the output of alsa-info.sh:
> 	http://hg.alsa-project.org/alsa/raw-file/tip/alsa-info.sh  

	I ran this script, and it only showed me the dialog program
getting a segmentation fault (probably my fault), but perhaps the
following information will be helpful:

% lspci -s 14.2
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
% lspci -n -s 14.2
00:14.2 0403: 1002:4383

	Vendor 0x1002, product 0x4383 in sound/pci/hda/hda_intel.c has
a pci_device_id entry with AZX_DRIVER_ATI in the extra data field.

	Also, Jeff Garzik's posting about having a similar problem
with a chip described by lspci as "Audio device: Intel Corporation
82801G (ICH7 Family) High Definition Audio Controller (rev 01)"
appears to correspond to PCI vendor 0x8086, PCI device ID 0x27d8,
which has AZX_DRIVER_ICH.


> In most cases, running the following commands solves the mixer issue:
> 
> 	% amixer set Master unmute 80%
> 	% amixer set Front unmute 100%
> 	% amixer set Headphone unmute 100%

	Thank you.  These commands give me approximately the old
volume levels.  In particular, the middle command seems to be the one
that effected the volume that I could hear.

	I hope the little bit of information about the PCI IDs that I
was able to provide above will be helpful.  Thanks again for your
quick response.

Adam J. Richter
