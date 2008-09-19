Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYISEnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYISEnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYISEnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 00:43:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.112.152]:12975 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYISEnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 00:43:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Thu, 18 Sep 2008 21:42:56 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
Date: Fri, 19 Sep 2008 12:42:52 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B331D47A6@hkemmail01.nvidia.com>
In-Reply-To: <s5h63ouvpfc.wl%tiwai@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH] add the nvidia HDMI codec driverfor	MCP77/79
thread-index: AckY0MsCWwBjEcnEQ2y7cJdVom2CewBO/dbw
References: <200809031558156739794@gmail.com><s5hhc8xpq6z.wl%tiwai@suse.de><15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com><s5h4p4xph6x.wl%tiwai@suse.de><48BE7EE4.8020800@insite.cz> <s5h63ouvpfc.wl%tiwai@suse.de>
From: "Wei Ni" <wni@nvidia.com>
To: "Takashi Iwai" <tiwai@suse.de>, "peerchen" <peerchen@gmail.com>
Cc: "Pavel Hofman" <pavel.hofman@insite.cz>, "Peer Chen" <pchen@nvidia.com>,
       "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 19 Sep 2008 04:42:56.0439 (UTC) FILETIME=[2F704470:01C91A12]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
