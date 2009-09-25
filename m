Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZIYLF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZIYLF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZIYLF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:05:26 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55738 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZIYLFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cYeaISzRNSJrxhLfTSN499CUFLIhQ9T4Tj+tfYSjVcYALJH8phRyisfio7vjnptGrm
         vQ/3rJlRTJ4RAjOXpa1aJ6DYkB6gZNDtc/6TCGSTMoQ2llYEbYrGQyf5K3eV77w9700S
         4iu6ETTWVPgwxqPGc746Ju+BxtLdA0d/faft4=
MIME-Version: 1.0
In-Reply-To: <11260.1253867067@redhat.com>
References: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
	 <7d86d44a0909242139v32a0ef6bh68386cbda31d0682@mail.gmail.com>
	 <11260.1253867067@redhat.com>
Date: Fri, 25 Sep 2009 19:05:28 +0800
Message-ID: <7d86d44a0909250405j60a0f27dncef8443a2d74b747@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data 
	can be mapped directly
From: graff yang <graff.yang@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Mundt <lethal@linux-sh.org>,
       Mel Gorman <mel@csn.ul.ie>, Greg Ungerer <gerg@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 4:24 PM, David Howells <dhowells@redhat.com> wrote:
> graff yang <graff.yang@gmail.com> wrote:
>
>> > +       if (capabilities & BDI_CAP_MAP_DIRECT) {
>>
>> This will breaks many drivers, e.g. some frame-buffer drivers, on NOMMU
>> system.  Because they don't have get_unmapped_area().  These drivers depend
>> on it's mmap() to return the frame-buffer base address.
>
> Then they won't work on NOMMU.  Read Documentation/nommu-mmap.txt:
>
>        ============================================
>        PROVIDING SHAREABLE CHARACTER DEVICE SUPPORT
>        ============================================
>
>        To provide shareable character device support, a driver must provide a
>        file->f_op->get_unmapped_area() operation. The mmap() routines will
>        call this to get a proposed address for the mapping. This may return an
>        error if it doesn't wish to honour the mapping because it's too long,
>        at a weird offset, under some unsupported combination of flags or
>        whatever.
>
> The chardev driver doesn't provide the virtual address through its mmap() fop
> in MMU-mode either - that's provided by do_mmap_pgoff().
>
> David
>
OK, I think do_mmap_pgoff() now looks nice with your patch.   Merely,
at least the alsa/fb driver
will crash due to the vm_region changes.
The alsa guys are fixing this issue:
http://mailman.alsa-project.org/pipermail/alsa-devel/2009-March/015802.html

Is there any other things be affected?

-- 
-Graff
