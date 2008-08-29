Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbYH2Swf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbYH2Swf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYH2Sw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:52:27 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:30073 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751342AbYH2Sw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:52:26 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 14:52:26 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.ar;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=TfglQylFrJ4PKDgnHT5V+BAnzDGvByX5JHJNcjeF60GGDbCZLNqRLk12PWy2KOiJmTJXknLC5TwopBqreNrq+QHB+teDcxTWbxOlX9UARK4A6GDt+rHwyOFyUssnAtsN22dK+xpIrddw2Xu5zqb0HfhRCErCsErPGkPTXcpvA9g=  ;
X-YMail-OSG: UBHOpKYVM1l3jl4RHu8AU9ArAptyLCxxNBtoxF25wuMyRckFXhej9THXVikITwKvOAyV9Cgodu9M90jVZ219PR7xUKOhlOYTvSTAIL3yv3bY_NEB6f.N_Eeal2jB7RUIBIodiJgDoGmifvPMnMvfUOkKIAityzBjTrYn
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48B843CC.1050805@yahoo.com.ar>
Date: Fri, 29 Aug 2008 15:45:32 -0300
From: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jari.aalto@cante.net
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, my english, again, very BAD!)

(not in mailing-list, please CC to me)


Jari Aalto <jari.aalto <at> cante.net> writes:

>> When booted kernel with no iommu parameter, it uses the iommu gart
>> (from amd) and the size of the aperture is 64MB You can try to grow
>> this size with iommu=memaper=2 for 128MB or 3 for 256MB. I don't have
>> experience with this, but i read that this, solves the problem.
>
>See my original bug report, which included experiences with
>memaper. Unofrtunately they didn't help:
>
>    REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread >start)
>
>but I'll try that once more with this 2.6.26 kernel to double check.

No your options are bad,

You have mixed options for "swiotlb" and "amd gart", see the
Documentation/x86_64/boot-options.txt

iommu=soft,memaper=3 swiotlb=65536 BAD.

memaper=3 don't have any effects here, memaper is only for "AMD GART"

The noagp option in this motherboard is redundant.

iommu=noagp,noaperture,off swiotlb=512M BAD combination options!
OFF, OFF, OFF, ON: The result are unknown.

You need to use the IOMMU (from AMD GART) that with your options: you
never used.

When you boot with no iommu options, kernels uses the AMD GART in this
system, with an aperture of 64MB (too small) to fix, you need only one
option: iommu=memaper=3

¡Buena suerte!



>
>> I have the similar hardware, but when boot in 64 bits, limit the
>> memory with mem=4G (discarded 0.5G that are (remaped from pci space)
>> beyond 4G) and iommu=noaperture. (This is not option for you, will be
>> discard 4G of RAM)
>
>Interestingly 'noaperture' together with 'noagp' has been the best
>option so far. It gives workign system for about week, but eventually
>the "out of IOMMU space" messages start appear.

>The system has always seen the full 8 GB memory without problems.


-- 
Gerardo Exequiel Pozzi ( djgera )
http://www.djgera.com.ar
KeyID: 0x1B8C330D
Key fingerprint = 0CAA D5D4 CD85 4434 A219  76ED 39AB 221B 1B8C 330D


