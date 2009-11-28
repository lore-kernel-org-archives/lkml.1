Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZK1PHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZK1PHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZK1PHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:07:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48338 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZK1PHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=joRik8W2Pelouphzu24PmF6JUo66/Kwa71ifkhydEp2/o9I/MtgMkW8JRIO4V3fduJ
         89vMWCXgQqB7+9OQQUqoYgBR0HrAfJ9phGQqTaUNjdEtuI1ALXsxBzIHkVPNrrzQSNb1
         dLy9yQcXdNr+YYPe5fBGxtQWbRZ9QHFYANQIw=
Message-ID: <4B113C9A.9050002@gmail.com>
Date: Sat, 28 Nov 2009 20:07:06 +0500
From: "Andrey A. Porodko" <andrey.porodko@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "A. Porodko" <panda@chelcom.ru>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: Sound support for Neuros OSD2 Davinci based board.
References: <4B0E7D5E.3080906@chelcom.ru> <20091127164733.GC11913@rakim.wolfsonmicro.main>
In-Reply-To: <20091127164733.GC11913@rakim.wolfsonmicro.main>
X-Enigmail-Version: 0.96.0
OpenPGP: id=9E6A5CCE
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Nov 26, 2009 at 06:06:38PM +0500, A. Porodko wrote:
>   
>> Hello,
>>
>> Here is a patch for Neuros OSD2 Davinci (DM6446) based board sound support.
>> Patch made against 2.6.32-rc6 kernel.
>>     
>
> This doesn't apply against current ASoC.  Could you please regenerate
> against this branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.33
>
>   
Mark Brown wrote:
> On Thu, Nov 26, 2009 at 06:06:38PM +0500, A. Porodko wrote:
>   
>> Hello,
>>
>> Here is a patch for Neuros OSD2 Davinci (DM6446) based board sound support.
>> Patch made against 2.6.32-rc6 kernel.
>>     
>
> This doesn't apply against current ASoC.  Could you please regenerate
> against this branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.33
>
>   
Hi,

I wish I knew how to do this. I'm new with git and anly learn how to
work with one tree.
Complex operations confuse me a little. I generated something, but it
doesn't look different from what I had before.

P.S. Reading alsa-project wiki didn't shed more light. For my main tree
is davinci tree and git is damn tricky.
---------------------------
>From 699bbf676a3e74989063b398ff662fcf40469a16 Mon Sep 17 00:00:00 2001
From: Andrey Porodko <panda@chelcom.ru>
Date: Mon, 23 Nov 2009 13:56:53 +0500
Subject: [PATCH] Davinci sound soc driver patch for Neuros OSD2 board
support.

Signed-off-by: Andrey Porodko <panda@chelcom.ru>
---
 sound/soc/davinci/davinci-evm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/soc/davinci/davinci-evm.c
b/sound/soc/davinci/davinci-evm.c
index 67414f6..ffdd30e 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -55,6 +55,9 @@ static int evm_hw_params(struct snd_pcm_substream
*substream,
     else if (machine_is_davinci_evm())
         sysclk = 12288000;
 
+    else if (machine_is_neuros_osd2())
+        sysclk = 27000000;
+
     else if (machine_is_davinci_da830_evm() ||
                 machine_is_davinci_da850_evm())
         sysclk = 24576000;
@@ -246,6 +249,9 @@ static int __init evm_init(void)
     if (machine_is_davinci_evm()) {
         evm_snd_dev_data = &evm_snd_devdata;
         index = 0;
+    } else if (machine_is_neuros_osd2()) {
+        evm_snd_dev_data = &evm_snd_devdata;
+        index = 0;
     } else if (machine_is_davinci_dm355_evm()) {
         evm_snd_dev_data = &evm_snd_devdata;
         index = 1;
-- 
1.5.6.5
-----------------------------------------

-- 
Best regards
Andrey A. Porodko
 



-- 
Best regards
Andrey A. Porodko
 

