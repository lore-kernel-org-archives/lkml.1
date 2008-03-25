Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYCYCpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYCYCpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYCYCov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:44:51 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49659 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYCYCou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:44:50 -0400
Message-ID: <47E8676B.7010700@keyaccess.nl>
Date: Tue, 25 Mar 2008 03:46:03 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080318032427.298BCDBA2@gherkin.frus.com> <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz> <47E6338E.8030001@orcon.net.nz> <47E7EFDF.2070706@keyaccess.nl> <47E83F94.8010409@orcon.net.nz> <47E8475E.4080705@keyaccess.nl>
In-Reply-To: <47E8475E.4080705@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------040704010104050006030304"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040704010104050006030304
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 25-03-08 01:29, Rene Herman wrote:

> On 25-03-08 00:56, Michael Cree wrote:

> 
>> At this stage I've run out of time to test the M-Audio Rev in the 
>> XP1000 and see if the MMAP disable patch help there.
> 
> Given that it fixes es18xx and cmipci on the PWS600au and that those 
> worked without trouble on the XP1000, you'd _expect_ not, but the OOPs 
> you posted before seemed to indicate that it stands a fair chance afer all.

Oh, by the way, note that it only disabled mmap for CONFIG_ALPHA_MIATA due 
to your report of es18xx working fine on the XP1000, so you'll have to 
change that to CONFIG_ALPHA_DP264 for the XP1000 to actually test it there:

(or just delete SNDRV_PCM_INFO_MMAP from the info structures in the driver 
as Takashi earlier instructed)

Rene.

--------------040704010104050006030304
Content-Type: text/plain;
 name="dp264_no_mmap.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dp264_no_mmap.diff"

diff --git a/include/sound/asound.h b/include/sound/asound.h
index 3eaf155..e3b9c2d 100644
--- a/include/sound/asound.h
+++ b/include/sound/asound.h
@@ -241,8 +241,14 @@ typedef int __bitwise snd_pcm_subformat_t;
 #define	SNDRV_PCM_SUBFORMAT_STD		((__force snd_pcm_subformat_t) 0)
 #define	SNDRV_PCM_SUBFORMAT_LAST	SNDRV_PCM_SUBFORMAT_STD
 
+#ifdef CONFIG_ALPHA_DP264
+#define SNDRV_PCM_INFO_MMAP		0		/* the useful comment goes here */
+#define SNDRV_PCM_INFO_MMAP_VALID	0
+#else
 #define SNDRV_PCM_INFO_MMAP		0x00000001	/* hardware supports mmap */
 #define SNDRV_PCM_INFO_MMAP_VALID	0x00000002	/* period data are valid during transfer */
+#endif
+
 #define SNDRV_PCM_INFO_DOUBLE		0x00000004	/* Double buffering needed for PCM start/stop */
 #define SNDRV_PCM_INFO_BATCH		0x00000010	/* double buffering */
 #define SNDRV_PCM_INFO_INTERLEAVED	0x00000100	/* channels are interleaved */

--------------040704010104050006030304--
