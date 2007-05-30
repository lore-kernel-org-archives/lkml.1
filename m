Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXE3Fys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXE3Fys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXE3Fyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:54:40 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:27049 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXE3Fyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uB40mmpqifrnvyLnoFYX6J/qMefPtcf3QiKOnNGxUx+hOdq3HusdaKISD6faLVFGURloi8B4Q9O8jDJu9j1UigGIETkGhSNRJb98dyui7MR7xQCuUeKruE1FbCISBlnS8QZJJ1pGfdTJlx5PIscuk4FNx9xdfEBm0RhfaOe1rAo=
Message-ID: <4cefeab80705292254k33079e90j52a32a813b12a887@mail.gmail.com>
Date: Wed, 30 May 2007 11:24:36 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <Pine.LNX.4.61.0705292236490.11140@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <Pine.LNX.4.61.0705292236490.11140@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On May 28 2007 20:04, Nitin Gupta wrote:
> >
> > * Changelog vs. original LZO:
> > 1) Used standard/kernel defined data types: (this eliminated _huge_
> > #ifdef chunks)
> > lzo_bytep -> unsigned char *
> > lzo_uint -> size_t
> > lzo_xint -> size_t
>
> Is this safe (as far as compressed LZO stream is concerned) --
> or is it even needed (could it be unsigned int)?
>
> > -                             m_pos -= (*(const unsigned short *)ip) >> 2;
> > -#else
> > -                             m_pos = op - 1;
> > -                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> > -#endif
> >
> > + m_pos = op - 1 - (cpu_to_le16(*(const u16 *)ip) >> 2);
> >
> > (Andrey suggested le16_to_cpu for above but I think it should be cpu_to_le16).
> > *** Need testing on big endian machine ***
>
> On i386, both cpu_to_le16 and le16_to_cpu do nothing.
> On sparc for example, cpu_to_leXX and leXX_to_cpu do 'the same' ;-)
> they swap 1234<->4321.
>
> It is the bytestream (ip) that is reinterpreted as uint16_t.
> And I really doubt that the LZO author has a big-endian machine,
> given the days of ubiquitous x86.

> le16_to_cpu it is.
>

I just missed the point that leXX_to_cpu() and cpu_to_leXX() are
identical on BE machine anyway. But then why you think it should be
le_16_cpu() -- how will this make any difference?

For your ref (from big_endian.h):
#define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
#define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))

- Nitin
