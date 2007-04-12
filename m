Return-Path: <linux-kernel-owner+w=401wt.eu-S1161133AbXDLJWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbXDLJWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161157AbXDLJWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:22:04 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:53501 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133AbXDLJWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:22:02 -0400
Date: Thu, 12 Apr 2007 11:22:00 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412092200.GB15666@uhulinux.hu>
References: <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <Pine.LNX.4.61.0704112048240.20436@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704112048240.20436@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 09:00:49PM +0200, Jan Engelhardt wrote:

> >+struct interval {
> >+  int first;
> >+  int last;
> >+};
> 
> CodingStyle? uint16_t instead of int?

> >+    { 0x1D173, 0x1D182 }, { 0x1D185, 0x1D18B }, { 0x1D1AA, 0x1D1AD },
> >+    { 0xE0001, 0xE0001 }, { 0xE0020, 0xE007F }, { 0xE0100, 0xE01EF }
> >+  };
> 
> Since Unicode above 0xFFFF is unsupported, could not these entries be killed?

The UTF-8 decoder part already supports full 31-bit Unicode (including 5 and
6 byte long UTF-8 sequences). It's only the font handling part that doesn't
support Unicode beyond BMP. If an application prints a non-BMP character
that is double-wide, or is a zero-width space, the expected behavior is to
move the cursor by two or zero positions. In order to do this, width
information is needed even beyond BMP.  It's a completely different story
that there would be no real glyph displayed, just e.g. a replacement symbol
followed by a space to pretend a real double-width character was printed.


> unsigned int rescan:1;
> unsigned int inverse:1;
> unsigned int width; or even uint8_t.
> I would not mind unsigned.

Okay.



-- 
Egmont
