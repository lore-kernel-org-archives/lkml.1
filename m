Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041Ab0A1JMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0A1JMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748Ab0A1JMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:12:35 -0500
Received: from mail1.perex.cz ([212.20.107.53]:57673 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0A1JMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:12:34 -0500
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 04:12:34 EST
Date: Thu, 28 Jan 2010 09:48:44 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
To: Wei Ni <wni@nvidia.com>
cc: "'Takashi Iwai'" <tiwai@suse.de>, "'akpm'" <akpm@linux-foundation.org>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Pavel Hofman'" <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel]  [PATCH]Change the AZX_MAX_PCMS to 10
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1BFEAFA4039@HKMAIL01.nvidia.com>
Message-ID: <alpine.LNX.2.00.1001280941120.25340@eeebox2.perex-int.cz>
References: <6B4D417B830BC44B8026029FD256F7F1BFEAFA4039@HKMAIL01.nvidia.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Wei Ni wrote:

> Hi, Takashi When I develop hdmi audio driver on the GT21x, I found a bug 
> in the had_intel.c In hda_codec.c, it has define "[HDA_PCM_TYPE_HDMI] = 
> { 3, 7, 8, 9, -1 },", it support up to device 9 for HDMI. But in 
> hda_intel.c, it only define AZX_MAX_PCMS as 8. So the GT21x have 4 hdmi 
> codecs, when run azx_attach_pcm_stream(), it will show error "Invalid 
> PCM device number 8", and "... number 9", and return "-EINVAL". We 
> should change the AZX_MAX_PCMS to 10.

I'm afraid, but having more than 8 PCM devices might cause problems when 
CONFIG_SND_DYNAMIC_MINORS is not set. At least, this condition 
(#if SNDRV_PCM_DEVICES < 10) should be handled in the HDA driver.

 					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

