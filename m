Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYGBK6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYGBK6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYGBK6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:58:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:61180 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYGBK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SvX5D2f/gjjOkxs5teH6J01MzAXtmPT9HTKvIjQ394bkn80NYXA1LCmylc/cfSRkSk
         KIQh7Tw77b7HUF5kyy8dNE9F7YFRE0Nr+Mo71luDXEhl/pbnHGW7yAbISaECyijPUrRz
         /B+wrpgUlOVVUuMQ97vtGWBL0vV33iJZ2uBDY=
Message-ID: <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com>
Date: Wed, 2 Jul 2008 12:58:05 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Philippe De Muyter" <phdm@macqel.be>
Subject: Re: mmap'ed memory in core files ?
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net, hidehiro.kawai.ez@hitachi.com
In-Reply-To: <20080702105027.GA1111@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701132149.GA32510@frolo.macqel>
	 <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>
	 <20080702105027.GA1111@frolo.macqel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+= hidehiro.kawai.ez@hitachi.com]

On Wed, Jul 2, 2008 at 12:50 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> Hi Michael,
>
> On Tue, Jul 01, 2008 at 08:16:11PM +0200, Michael Kerrisk wrote:
>> On 7/1/08, Philippe De Muyter <phdm@macqel.be> wrote:
>> > Hello everybody,
>> >
>> >  I develop video acquisition software using the video1394 interface.
>> >  The images grabbed by the camera and iee1394 bus are kept in kernel
>> >  memory and made available to the user program through a mmap call done
>> >  in the libdc1394 library :
>> >
>> >  dma_ring_buffer= mmap(0, vmmap.nb_buffers * vmmap.buf_size,
>> >                 PROT_READ|PROT_WRITE,MAP_SHARED, craw->capture.dma_fd, 0);
>> >
>> >  Sometimes, my program crashes and produces a core file :)  It seems to
>> >  me that the core file does not contain the mmap'ed memory and hence
>> >  I cannot replay my program with the same image for debugging purpose.
>> >
>> >  Is it possible to configure the kernel through /proc, or through the mmap
>> >  system call to have that mmapped segment in the core file, or do I need
>> >  to modify the kernel itself to obtain the behaviour I want ?  If I
>> >  need to modify the kernel, can some kind soul provide me some pointers ?
>>
>>
>> Have a look at the section "Controlling which mappings are written to
>> the core dump" in a recent core.5 man page:
>> http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html
>
> thanks for the info.  I didn't know about /proc/PID/coredump_filter.
>
> that part was promising :
>
>       bit 2  Dump file-backed private mappings.
>       bit 3  Dump file-backed shared mappings.
>
>    The default value of coredump_filter is 0x3; this reflects traditional
>    Linux behavior and means that only anonymous memory segments are dumped.
>
> Unfortunately, the part that applies to me (I have tested it) is the next one :
>
>    Memory-mapped I/O pages such as frame buffer are never dumped, [...],
>    regardless of the coredump_filter value.
>
> Is that a design decision, or a mere finding of the way it is implemented
> now ?
>
> So, back to my original question :
>
> Can some kind soul provide me some pointers to the way I should modify
> the kernel to make the inclusion of the video1394 mmapped segment in
> core files possible ?

Perhaps Hidehiro, who wrote the coredump_filter feature, can provide insight.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
