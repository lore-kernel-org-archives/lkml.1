Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXFVF4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXFVF4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbXFVF4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:56:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:35037 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXFVF43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZXsQGKaeRguiXkU4dHawcUpj8MyKQwfQPqJECOHvIeH8MCMHHNkJo1Pylvjy6rA+tit0TCzKfQ+cQQA1vgpxzXUXukGWDLJd2sDKQ4vklAaLGHxhgImtvMzdBMEcCOw3/KtAzevw8aHD8zEOEg2qwcVV6Rpf3LUiq2GvMA6ULkU=
Message-ID: <787b0d920706212256u7e78ba6n15ef41bcea99aff0@mail.gmail.com>
Date: Fri, 22 Jun 2007 01:56:28 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: JIT emulator needs
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1182447884.2704.7.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <1182447884.2704.7.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 2007-06-08 at 02:35 -0400, Albert Cahalan wrote:
> > Right now, Linux isn't all that friendly to JIT emulators.
> > Here are the problems and suggestions to improve the situation.
> >
> > There is an SE Linux execmem restriction that enforces W^X.
> > Assuming you don't wish to just disable SE Linux, there are
> > two ugly ways around the problem. You can mmap a file twice,
> > or you can abuse SysV shared memory. The mmap method requires
> > that you know of a filesystem mounted rw,exec where you can
> > write a very large temporary file. This arbitrary filesystem,
> > rather than swap space, will be the backing store. The SysV
> > shared memory method requires an undocumented flag and is
> > subject to some annoying size limits. Both methods create
> > objects that will fail to be deleted if the program dies
> > before marking the objects for deletion.
>
> and these methods also destroy yourself on any machine with a looser
> cache coherency between I and D-cache....
>
> for all but x86 you pretty much have to do the mprotect() between the
> two states to deal with the cache flushing properly...

If the instructions to force data write-back and/or to
invalidate the instruction cache are priveleged, yes.
AFAIK, only ARM is that lame.

For example, PowerPC lets unprivileged code run
the required instructions.
