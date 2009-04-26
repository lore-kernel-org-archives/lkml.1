Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZDZQp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZDZQp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZDZQpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:45:18 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2171 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZDZQpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:45:16 -0400
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 12:45:16 EDT
Message-ID: <49F48A0E.30301@phoenixsoftware.de>
Date: Sun, 26 Apr 2009 18:21:34 +0200
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: The current status of info, err and warn macros in kernel
References: <49F39786.6020303@pardus.org.tr>
In-Reply-To: <49F39786.6020303@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.249 () AWL,BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan schrieb:
> I noticed that I can't compile some out-of-tree modules like lirc,
> lmpcm_usb on my 2.6.30_rc* source tree.
> The compiler aborts saying "implicit declaration of function 'info'". [...] 
> I don't think that those macros are completely removed because it seems
> that they're still heavily in use
> after grepping on current linus-2.6 tree.

Your grepping must have been inexact. info() and warn() have been removed
completely in 2.6.29 already, and are indeed used nowhere in the current
tree. (err() is still there, though probably not for long.)

Suitable replacements are either the dev_* macros from device.h (only
usable if there is a reliably valid device pointer available - be
careful when using them in error handling!) or the pr_* macros from
kernel.h with an appropriate definition of pr_fmt(f).

> So, is it possible that there's a Kconfig option which makes the
> compilation fail on those macros?

Definitely not. They are gone, period.

> Why am I not able to compile those modules? Am I missing something?

The out-of-tree modules have to be adapted for kernel release 2.6.29.
That's the fate of out-of-tree modules - they tend to break with every
other new kernel release.

HTH
Tilman
