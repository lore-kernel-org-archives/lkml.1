Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXIPUqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXIPUqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXIPUqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:46:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:48781 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbXIPUqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ww/f3W96rDSPsTK+L34fJVan6o1AtUbY3iBnSatto/3OuK3JmQ/YYIykNbEpCKLoaomSpsBie8DakxIcxNBi10pBIoF85hI5QHtuKxnxkxSkpkVlF4CUXPTHe8i85clBUPlOWBsO+bEinjhh9t9R7koSUoLZCHoDke8+QqpQl3c=
Message-ID: <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
Date: Sun, 16 Sep 2007 13:46:29 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: x86_64: vsyscall vs vdso
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/07, Francis Moreau <francis.moro@gmail.com> wrote:
> I'm a bit puzzled because vdso doesn't seem to be used on my fedora 7:
> I just compiled a trivial program which just call gettimeofday() and
> ld.so resolves this call with vsyscall's gettimeofday.
>
> Now I'm wondering when vdso is used, could anybody give me a clue ?

F7 was released before the vdso for x86_64 was upstream so you should
not expect anything else.  F8 will use the available vdso.  This
doesn't just happen magically, changes to libc are needed.


> Another question: is vdso going to replace vsyscall at all ? If so how
> are statically programs going to be handled ?

Unfortunately the vsyscalls cannot ever go completely away.
Statically linked apps, the bane of progress, will need them.  There
are also people updating kernels but not the user userland code.

What we will have to do in future is to make vsyscalls configurable.
Both a compile time option and a runtime option (perhaps also under
control of SELinux) are likely needed.
