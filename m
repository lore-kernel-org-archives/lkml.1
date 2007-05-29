Return-Path: <linux-kernel-owner+w=401wt.eu-S1765947AbXE2U6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765947AbXE2U6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbXE2U5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:57:54 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57847 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533AbXE2U5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:57:53 -0400
Date: Tue, 29 May 2007 22:48:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Nitin Gupta <nitingupta910@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
In-Reply-To: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705292236490.11140@yvahk01.tjqt.qr>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28 2007 20:04, Nitin Gupta wrote:
>
> * Changelog vs. original LZO:
> 1) Used standard/kernel defined data types: (this eliminated _huge_
> #ifdef chunks)
> lzo_bytep -> unsigned char *
> lzo_uint -> size_t
> lzo_xint -> size_t

Is this safe (as far as compressed LZO stream is concerned) --
or is it even needed (could it be unsigned int)? 

> -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> -#else
> -                             m_pos = op - 1;
> -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> -#endif
>
> + m_pos = op - 1 - (cpu_to_le16(*(const u16 *)ip) >> 2);
>
> (Andrey suggested le16_to_cpu for above but I think it should be cpu_to_le16).
> *** Need testing on big endian machine ***

On i386, both cpu_to_le16 and le16_to_cpu do nothing.
On sparc for example, cpu_to_leXX and leXX_to_cpu do 'the same' ;-)
they swap 1234<->4321.

It is the bytestream (ip) that is reinterpreted as uint16_t.
And I really doubt that the LZO author has a big-endian machine,
given the days of ubiquitous x86. le16_to_cpu it is.



	Jan
-- 
