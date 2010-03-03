Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0CCNHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:07:24 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39435 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0CCNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YWE6vj8fnIOKHS3bMI9yycc/vKtspTVqIg31mJqzmenjj+WJI9zd1zFlTr8VfRqy6+
         1wTt4m9lyD4GGplcJGdYTbVHfrYKCHrIdLh5+dwmFqIxn6bf05EdAlNiWKoiam4oTZth
         mStvKMngX+pe3NBZJd9iUgavCg+AstdhqS9H8=
MIME-Version: 1.0
In-Reply-To: <404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <20100303103405.127020d8@hyperion.delvare>
	 <404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
Date: Wed, 3 Mar 2010 14:07:19 +0100
Message-ID: <63386a3d1003030507l25e32ec2u92610cf40a91e538@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dima Zavin <dmitriyz@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/3 Dima Zavin <dmitriyz@google.com>:

> there are plenty of
> drivers floating out there from many OEMs/vendors

Bad for them that they didn't work on integrating these to the
mainline kernel and creating proper subsystems for them
earlier.

> that are not ALSs,
> but essentially need a similar interface (e.g. proximity sensor).

I have a proximity sensor driver pending here on top of GPIO,
creating an input-on-top-of-GPIO driver framework. Too much
to do but here is the userspace interface:

diff --git a/include/linux/input.h b/include/linux/input.h
index a5802c9..cbe8a98 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -644,6 +644,7 @@ struct input_absinfo {
 #define SW_RADIO		SW_RFKILL_ALL	/* deprecated */
 #define SW_MICROPHONE_INSERT	0x04  /* set = inserted */
 #define SW_DOCK			0x05  /* set = plugged into dock */
+#define SW_PROXIMITY		0x06  /* set = prox. sensor detects object */
 #define SW_MAX			0x0f
 #define SW_CNT			(SW_MAX+1)

-- 

Comes in through /dev/input/event* something, simple.

I have heard about proximity sensors returning more than a binary
value, do you have one of those?

Yours,
Linus Walleij
