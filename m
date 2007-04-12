Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXDLOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXDLOGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDLOGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:06:50 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:44734 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXDLOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:06:49 -0400
Date: Thu, 12 Apr 2007 16:06:48 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412140648.GA4777@uhulinux.hu>
References: <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412125412.GA729@uhulinux.hu> <20070412141306.0c1b6820@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070412141306.0c1b6820@the-village.bc.nu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 02:13:06PM +0100, Alan Cox wrote:

> You can pack them a little differently and they'll shrink a lot.

The smaller table would actually slightly grow instead of shrinking. In my
patch there are 11 intervals, each consume 2*4 bytes, that's 88 bytes. Your
variant would store each interval in 3 bytes, that's 33 bytes so far, plus
you need 4 byte values in the toptab array, that's 64 more bytes.

The larger table is 984 byte large now (123 intervals). You cannot compress
each interval to 3 bytes (at least not the way you described) since the
index for toptab needs more than 16 possible values. But it's easily
possible to compresss each interval in 4 bytes. That's 492 bytes for the
intervals themselves, plus at least 64 bytes for toptab (oh, probably it's
possible to store 3 byte values in toptab, too).

You might gain approx. 400 bytes in a table that's actually commented out in
the current patch since HPA doesn't like the behavior where it would be
used. On the other hand, you get a database that is harder to understand,
maintain, verify, you get code that runs a little bit slower. We're from
different worlds. You're a great kernel hacker and bit-magician. I'm rather
developing applications, so for me having a less straightforward code to
save 400 bytes is simply not worth it.

Which version would fit in the spirit of the kernel better? I don't know,
I'd let you decide it :)


bye,
Egmont
