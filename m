Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZELJET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZELJET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZELJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:04:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:56644 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZELJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lu1hVUu1RSv3BTdMwpZQMNrpq1Xv8oJJj8zzp3dd8pK8sX5+3sgMPLG3tMNRPfMGgo
         Gpx9wZfkyhGJ4AkSjof9vwvPeBfzTjIW/l0CKaSm6OKYTCtAeBnw/G9NHRjiAaCkma9r
         70YdZRa6PxgBeupQbv3zu/0+bEPLJS6Gn8YLA=
MIME-Version: 1.0
Date: Tue, 12 May 2009 17:04:07 +0800
Message-ID: <8fda62c20905120204oafee94bn96af7230c7995929@mail.gmail.com>
Subject: ALSA for SoC audio support full duplex problem
From: jinjin xu <freebsdxjj@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use 2.6.21.5-cfs-v19 on S3C6410(arm),use wm8987 sound card(i2s interface)

It is not work correct  in full duplex.
I grep and diff the drivers

ens1370.c:

  snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_ensoniq_playback1_ops);

  snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_ensoniq_capture_ops);


soc-core.c:

        if (playback)
        {

                snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &soc_pcm_ops);

        }

        if (capture)
        {

                snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &soc_pcm_ops);
        }


ens1370.c use two different fops for playback and record(I test it in
Vmware,It can run on full duplex)
soc-core.c use the same fops for  playback and record

It that the problem ?
So how to fix it for support full duplex?

Thanks!
