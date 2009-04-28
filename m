Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZD1Tdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZD1Tdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZD1Tda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:33:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60906 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbZD1Td3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:33:29 -0400
Message-ID: <49F75A07.6090001@garzik.org>
Date: Tue, 28 Apr 2009 15:33:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Takashi Iwai <tiwai@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: include/sound/soc-dai.h: "codec" declared twice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling with LLVM's clang yielded this:

> include/sound/soc-dai.h:224:25: error: member of anonymous union redeclares 'codec'
>                 struct snd_soc_codec *codec;
>                                       ^
> include/sound/soc-dai.h:214:24: note: previous declaration is here
>         struct snd_soc_codec *codec;
>                               ^
> 2 diagnostics generated.

And indeed, we see

struct snd_soc_dai {
[...]
         /* DAI runtime info */
         struct snd_pcm_runtime *runtime;
         struct snd_soc_codec *codec;

[...]
         /* parent codec/platform */
         union {
                 struct snd_soc_codec *codec;
                 struct snd_soc_platform *platform;
         };

         struct list_head list;
};

