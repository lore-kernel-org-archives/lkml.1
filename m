Return-Path: <linux-kernel-owner+w=401wt.eu-S935507AbYD1P2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935507AbYD1P2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934204AbYD1P20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:28:26 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:52103 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060AbYD1P2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:28:25 -0400
Message-ID: <4815ED15.3080702@zoopnet.de>
Date: Mon, 28 Apr 2008 17:28:21 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, yhlu.kernel@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
   layout v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	<200804280206.52641.yhlu.kernel@gmail.com>	<20080428130826.GH27997@elte.hu> <20080428064925.318659b9@laptopd505.fenrus.org>
In-Reply-To: <20080428064925.318659b9@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven schrieb:
> yep one should not touch existing MTRRs. If you run out, tough luck.
> Thats what we have PAT for.
> Changing them anyway is a deathtrap with various things, suspend/resume being only
> one of the nasty cases.

Hm. I currently have to remove the offending (i.e. overlapping my video
memory) MTRRs and split them so that they have a hole where my video
memory is.

Only that makes the X server happy, which wants to set up a
write-combining range covering the video memory.

Is there a better workaround?

>> how relevant is this feature with modern Xorg? I thought modern Xorg 
>> would get its mappings via /sys, hence it would not have to touch
>> MTRRs at all.
> 
> that's true for current X, but not for 6 month old X :=(

Ah, so the new X will be able to use the video memory in write-combining
mode even if I have an MTRR saying this area is uncachable or write-back?

If that is the case, then I agree that this patch is not really needed.

Regards,
 Mika
