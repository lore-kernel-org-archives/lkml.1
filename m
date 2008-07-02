Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbYGBFOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbYGBFOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYGBFO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:14:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:60509 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYGBFOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v4Uza7PKKwd+y0+P+VGJyoNxWnWbe8t/VD9cbwmhHIFAJjcDHGiPrOgAkaZRw/RMVF
         okIkQqpMwEE+fsP6OzwGzsl5OC32/TykJ9fDxcqkS0T3n/vC31sJMb4Zmz0HUgeuJtSZ
         AeR5RFXF49sOaN5YDObxrXsPD1IAeA4NAgxZ0=
Message-ID: <cfd18e0f0807012214o78353faal84a5fa764d3210bf@mail.gmail.com>
Date: Wed, 2 Jul 2008 07:14:22 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bron Gondwana" <brong@fastmail.fm>
Subject: Re: mmap'ed memory in core files ?
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Philippe De Muyter" <phdm@macqel.be>, linux-kernel@vger.kernel.org,
       robm@fastmail.fm
In-Reply-To: <20080701214423.GA29875@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701132149.GA32510@frolo.macqel>
	 <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>
	 <20080701214423.GA29875@brong.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 11:44 PM, Bron Gondwana <brong@fastmail.fm> wrote:
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
> Interesting (and somewhat off topic to your conversation here) - it
> appears that when dumping mappings, the kernel ignores the maximum
> core size set with "limit".
>
> This is particularly interesting on a 64 bit kernel where a bug in
> your code causes you to try to read something about 2Gb into your
> alleged mmaped file (actual size ~500 bytes) and the segfault causes
> a coredump.

Do you have a ssimple example program for this?

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
