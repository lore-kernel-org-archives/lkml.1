Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYKRRGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYKRRGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKRRG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:06:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:23913 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYKRRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:06:25 -0500
Message-ID: <154e089b0811180906r69099866vf0b80cd40d7e2cc7@mail.gmail.com>
Date: Tue, 18 Nov 2008 18:06:23 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH] sound: Fix warnings relating to ignored return value in snd_card_register
Cc: "Jaroslav Kysela" <perex@perex.cz>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5hej19dn9o.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <154e089b0811180759x4db4ba61k467fa2275710938f@mail.gmail.com>
	 <s5hej19dn9o.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not ignore the return of 'device_create_file' in
'snd_card_register' and thereby fixing the following warnings:

sound/core/init.c: In function 'snd_card_register':
sound/core/init.c:640: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result
sound/core/init.c:641: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

On Tue, Nov 18, 2008 at 11:14 AM, Takashi Iwai <tiwai@suse.de> wrote:
> The changes look good, but please run checkpatch.pl to your patch and
> fix the coding style issues suggested there.

I did not fix:

"WARNING: line over 80 characters" as they a hardly longer than 80
characters and there are lines longer than this in the same file.

"ERROR: do not use assignment in if condition" as this pattern seems
to be quite common.

Comments? Should I fix them?

 sound/core/init.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index af1e407..814d834 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -637,8 +637,10 @@ int snd_card_register(struct snd_card *card)
 #endif
 #ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
-		device_create_file(card->card_dev, &card_id_attrs);
-		device_create_file(card->card_dev, &card_number_attrs);
+		if ((err = device_create_file(card->card_dev, &card_id_attrs)) < 0)
+			return err;
+		if ((err = device_create_file(card->card_dev, &card_number_attrs)) < 0)
+			return err;
 	}
 #endif
 	return 0;
