Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbXIWQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbXIWQh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXIWQhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:37:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:2926 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbXIWQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XmHXeaBP15w4TB6qEo3xORYVzWMiBe1wSg3A1hnk3dOonv0yU0SzJ0iqPw2TTHopRsRhVyhmtcttu0HItY/WgQgFY/VAZTGDeUkJjfGoTfgkGNmp0oxz9vDaXYB813vZSXx2aTbNbgudeAIJN6tUbwjefDBwqc6tnvkcrV56GPA=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Sun, 23 Sep 2007 19:37:13 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709220828.00078.mihai.dontu@gmail.com> <200709221746.14429.mihai.dontu@gmail.com> <1190542810.3723.27.camel@localhost.localdomain>
In-Reply-To: <1190542810.3723.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709231937.13595.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2007, Benjamin Herrenschmidt wrote:
> Heh, yup.
> 
> There have been some radeonfb patches around -rc6 or so. Can you try
> backing them out and letting us know if that helps a) ?
> 
> In that case, Linus, we probably want to revert them...
> 
> Though looking at your PCI ID (5955), I don't think the patches should
> have changed anything.

After four hours of bisecting, I got this, which dates back to 2.6.21, but
I've been on 2.6.21.3 for too long and thus missed the commit (I just decided
to be a good citizen and test things before they get out).

dd1447134454b169d5ae353aceb93f2368db8547 is first bad commit
commit dd1447134454b169d5ae353aceb93f2368db8547
Author: johan henriksson <jhn98032@gmail.com>
Date:   Tue May 8 00:37:59 2007 -0700

    radeonfb: Add support for Radeon xpress 200m

    Added support for radeon xpress 200m(rs480).  Note that the card doesn't
    like dynclk turned on.

    Signed-off-by: Johan Henriksson <jhn98032@gmail.com>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: "Antonino A. Daplas" <adaplas@pol.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 e553664a656ee329152789818b5b071a36ac1e45 0a698ad7daa8cdfd9eb5304812845306c9feb2f9 M      drivers

I turned dynclk off, no result (although dynclk is preferred).

What is interesting, is that the driver ignores "vga=normal" and "jumps" to
a quite high res (I think is 1024x768 or something; the fonts look really nice
though :)).

-- 
Mihai Donțu
