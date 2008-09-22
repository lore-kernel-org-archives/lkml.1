Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYIVGe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYIVGe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 02:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYIVGeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:34:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.112.152]:9844 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYIVGeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:34:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Sun, 21 Sep 2008 23:34:06 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
Date: Mon, 22 Sep 2008 14:33:58 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B3332408C@hkemmail01.nvidia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
thread-index: AckY0MsCWwBjEcnEQ2y7cJdVom2CewBO/dbwAJtFHSA=
References: <200809031558156739794@gmail.com><s5hhc8xpq6z.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com><s5h4p4xph6x.wl%tiwai@suse.de><48BE7EE4.8020800@insite.cz> <s5h63ouvpfc.wl%tiwai@suse.de> 
From: "Wei Ni" <wni@nvidia.com>
To: "Takashi Iwai" <tiwai@suse.de>, "peerchen" <peerchen@gmail.com>
Cc: "Pavel Hofman" <pavel.hofman@insite.cz>, "Peer Chen" <pchen@nvidia.com>,
       "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 22 Sep 2008 06:34:06.0332 (UTC) FILETIME=[363E6BC0:01C91C7D]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takashi

About the "long delay", it seemed that we need to add this "delay" to
fix some issue on our aza controller.
Because it related with the controller, not just codec, so I think this
flag should not be added in codec-initialization part.
I think it's better to add the flag in that place which I submitted.

Thanks

-----Original Message-----
From: Wei Ni 
Sent: Friday, September 19, 2008 12:43 PM
To: 'Takashi Iwai'; peerchen
Cc: Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
MCP77/79

Thanks for your reply.

About the "long delay", we had some problems on reading RIRB buffer when
testing this driver, so we add this "delay"
We will try to find a best way to fix this issue.

And we didn't familiar with git, we will research it more such as
"rebase" and then submit the patch file again.

Thanks

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Wednesday, September 17, 2008 10:05 PM
To: peerchen
Cc: Wei Ni; Pavel Hofman; Peer Chen; alsa-devel; linux-kernel; akpm
Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor
MCP77/79

At Wed, 17 Sep 2008 17:00:04 +0800,
peerchen wrote:
> 
> new patch base on git tree.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> Signed-off-by: Peer Chen <peerchen@gmail.com>

Thanks!

But, the patch looks like no "rebase".  You secretly added a new
function call that wasn't in your previous patch, namely...

> diff -uprN -X linux-2.6-tiwai-sound/Documentation/dontdiff
linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c
linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
> --- linux-2.6-tiwai-sound/sound/pci/hda/hda_intel.c	2008-09-10
17:40:52.000000000 +0800
> +++ linux-2.6-tiwai-sound-niwei/sound/pci/hda/hda_intel.c
2008-09-10 17:49:31.000000000 +0800
> @@ -1220,6 +1220,9 @@ static int __devinit azx_codec_create(st
>  	if (err < 0)
>  		return err;
>  
> +	if (chip->driver_type == AZX_DRIVER_NVIDIA)
> +		chip->bus->needs_damn_long_delay = 1;
> +

Do we really need this inevitably?  I don't think so -- otherwise I
would have far more bug reports.

This flag is the last resort and should be avoided as much as
possible.  This results in a significant slow down of suspend/resume
speed, for example.

If it's really needed with some devices and there is no other way to
fix it, add this flag rather in the codec-initialization part.

Also, if you resend a patch, please add the original patch description 
again.  This helps my patch work a lot indeed.


thanks,

Takashi
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
