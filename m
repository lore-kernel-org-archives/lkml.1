Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXLSSq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXLSSq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXLSSqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:46:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:53283 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXLSSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W+6XGkLPXx4O3VCNPZaU+JgVNj16fdkTs5gU8yH/Iszf/1O1Spnu6eFzNQq9oCRnbjY5G9PAy+UyFSbrSkq+9C5C36x3yk0JxbsZtI8hwMMxm7K7BeQCjYSlNEz6Atyq7fCQDZGS7Gatv0FVCC7/xmYEytFZo/RqTAwxCVyO/G4=
Message-ID: <9e0cf0bf0712191046q702eefb0vdd0526360eceddc1@mail.gmail.com>
Date: Wed, 19 Dec 2007 20:46:46 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [MIPS] Build an embedded initramfs into mips kernel
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-mips@ftp.linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071218224702.GI15227@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com>
	 <47683B2D.9030608@zytor.com>
	 <9e0cf0bf0712181409p2475e1fdk779fdee4fa274722@mail.gmail.com>
	 <20071218224702.GI15227@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your help.
Indeed the dynamic loader of uclibc is the cause.
I upgraded to latest uclibc-0.9.29, and finally the files was linked
against uclibc's ld.
But it did not work...
Tried to run a dynamic linked executable via static shell, and got
floating point exception.
Tried to compile toolchain and uclibc with softfloat, but still did not work.
So I moved to glibc and all works correctly.

Thank you for quick response!
I will continue the discussion at uclibc lists.

Best Regards,
Alon Bar-Lev.

On 12/19/07, Willy Tarreau <w@1wt.eu> wrote:
> On Wed, Dec 19, 2007 at 12:09:46AM +0200, Alon Bar-Lev wrote:
> > On 12/18/07, H. Peter Anvin <hpa@zytor.com> wrote:
> > > Make sure your /init doesn't depend on an interpreter or library which
> > > isn't available.
> >
> > Thank you for your answer.
> >
> > I already checked.
> >
> > /init is hardlink to busybox, it depends on libc.so.0 which is available at /lib
>
> Are you sure that libc.so.0 is enough and that you don't need any ld.so ?
>
> > But shouldn't I get a different error code if this is the case?
>
> If it does not find part of the dynamic linker or libraries, this error
> makes sense to me.
>
> You should try to build a static init with any stupid thing such as a
> hello world to ensure that the problem really comes from the init and
> nothing else.
>
> Regards,
> Willy
>
>
