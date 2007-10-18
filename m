Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbXJRBwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbXJRBwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764296AbXJRBwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:52:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:42435 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764020AbXJRBwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VrgLMZV7GqTd2ihrwTd3de8WkNv/se0sZy4GQ7OW3lOSE6Yc8hRt+Xiw2fdQtSUh3omrCXCztHBDgUPs7J68iMIVEyxaOAQPClEjklWstPQnDndPYsNEXrptjSz/BRk1lFPJqQIIdkEkyt68Wlh3LMvdUTMzE7YyhUZLyLCZFlU=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 03:51:50 +0200
User-Agent: KMail/1.9.6
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <471538C2.80806@m3y3r.de> <s5h8x622kui.wl%tiwai@suse.de> <471651C4.20907@m3y3r.de>
In-Reply-To: <471651C4.20907@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710180351.50618.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I understand why this happens.

Your sound card has a single "headphone" output, and since it is single, it is called "Master"
the stac you have also has a real master volume control, that controls all the DACs, not just the headphones.

I added support for it, thus two controls collided.

The  following patch will rename the "Master" output to "Headphone"
Note that on the stac 9205/9204, the only one that has no master volume (the volume knob)
but has a "Master Volume" amplifier widget, this will probably rename the "Master Volume" to
Headphones.

This chip is quite different, thus I think this should be handled in its patch function.
I see what I can do later.
Meanwhile the rename from "Master" to Headphones" is the only regression.

Best regards,
	Maxim Levitsky

PS: I reply to this mail with the patch.
