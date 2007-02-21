Return-Path: <linux-kernel-owner+w=401wt.eu-S1161329AbXBUQO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329AbXBUQO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161331AbXBUQO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:14:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:25991 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161329AbXBUQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:reply-to:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=TAgd6mqE5l4V/812vki8q66ttsv3d4V9RLLXUoYMyOV91cHp7YuIaR2UIYY9rG3wksEa+g7FnYFPpmUC+lf5JNuIfWLpw1Vbrc+6X/ZLow6yiqqW9QGHxn3JiNN9BfTXaa/wweBvjTU+cmuZb7A8sMGifFh5dFFrLcIpcPnZd/M=
Date: Wed, 21 Feb 2007 18:14:27 +0200
From: Paul Sokolovsky <pmiscml@gmail.com>
Reply-To: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <5110512908.20070221181427@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Advice on backlight support
In-Reply-To: <20070221160213.GK4641@enneenne.com>
References: <20070221160213.GK4641@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rodolfo,

Wednesday, February 21, 2007, 6:02:13 PM, you wrote:

> Hello,

> I'd like to add backlight support for input devices since my custom
> board has a backlighted mini keyboard.

  There's already generic indicator API, currently mostly known as
"[new] LED [classdev] API", even though it is already used for things
like buzzers, vibrators, etc. Why wouldn't it be suitable for your
case?

  LCD and LCD backlight are special cases, as they actually should
track state of (abstract) FB device, and keeping their states in sync
is pretty important for trivial PM and info accessibility, so worth
doing on kernel level.

  As for things like "light up keyboard if key was pressed, then light
down after timeout", or "light up backlight LCD on touchscreen touch,
light down on timeout", that can be pretty well done in userspace, no?

> It could be acceptable to move the code from drivers/video/backlight/
> to drivers/backlight/ renaming the "Backlight & LCD" name into
> "Backlight" and adding two new entries "LCD" and, maybe, "Input" (or
> something like that?).

  Yes, the fact that lcd.c (LCD power control) lives under backlight
dir, is a bit confusing. But they still has close relation to FB,
after all.

> Thanks in advance,

> Rodolfo




-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

