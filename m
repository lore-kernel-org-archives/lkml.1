Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZHBQwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZHBQwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZHBQwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:52:14 -0400
Received: from norkia.v3.sk ([92.240.234.41]:35913 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbZHBQwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:52:13 -0400
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 12:52:13 EDT
Subject: Re: [PATCH] Tell user that stream to be rewound is suspended
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Lennart Poettering <mzjro@0pointer.net>, stable@kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <1249229684-8292-1-git-send-email-lkundrak@v3.sk>
References: <1249229684-8292-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 18:32:57 +0200
Message-Id: <1249230777.4890.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 18:14 +0200, Lubomir Rintel wrote:
> Return STRPIPE instead of EBADF when userspace attempts to rewind
> of forward a stream that was suspended in meanwhile, so that it
> can be recovered by snd_pcm_recover().
> 
> This was causing Pulseaudio to unload the ALSA sink module under a race
> condition when it attempted to rewind the stream right after resume from
> suspend, before writing to the stream which would cause it to revive the
> stream otherwise. Tested to work with Pulseaudio patched to attempt to
> snd_pcm_recover() upon receiving an error from snd_pcm_rewind().

The userspace part is filed here:
http://www.pulseaudio.org/ticket/616

-- 
"Excuse all the blood" -- Dead

