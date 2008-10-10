Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYJJFE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYJJFE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYJJFEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:04:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:52255 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYJJFEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=nr1b5XEvVH2v7EIOE5phL4yAMe2iwohyCibE3SiT1Im9Xbp/UGcy87wJ3QU2XH1WIH
         4vRFQyjuZV90eet6+l9xTtcvcIFi7vuhjwqfArt2Tu+yUxNjeVWjgonFM7zLnB37yExj
         2h8O4h6OLxNuK0XZl4ZdPuYshleRJ5HoSO1HY=
Message-ID: <cfd18e0f0810092204n50f88887t7776133620eff75b@mail.gmail.com>
Date: Fri, 10 Oct 2008 07:04:19 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: dup2() vs dup3() inconsistency when
Cc: "Ulrich Drepper" <drepper@redhat.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48EE703C.7070901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
	 <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com>
	 <48EE6CD6.10007@zytor.com> <48EE6F22.5070306@redhat.com>
	 <48EE703C.7070901@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 10:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ulrich Drepper wrote:
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> H. Peter Anvin wrote:
>>>
>>> The result of dup3(fd, fd, O_CLOEXEC) is to set the O_CLOEXEC flag on fd.
>>
>> That's bad and disregarded by Al and myself because it is one and the
>> same descriptor and therefore it changes the source descriptor.
>
> It's not the source descriptor, per se, it is the "new" descriptor, which
> happens to have a side effect of closing the "old" descriptor.
>
>>> Step (2) could be considered a bit dubious, but the behaviour of
>>> dup2(fd, fd) is a direct consequence of the chosen semantics.
>>
>> The behavior of dup2(fd,fd) is just a result of an accident in the
>> original implementation.  It makes no sense and the mistake doesn't have
>> to be repeated.
>
> Inconsistency is bad, too, and one could *definitely* argue that the
> fundamental problem is the one of closing a pre-existing descriptor rather
> than forcing the user to do that explicitly if that behaviour was desired.

Well, as long as we are fixing the dup3() interface in the way that Al
and Ulrich have suggested, what about another fix:

give an error if newfd is already open, thus forcing the user to do an
explicit close

?

This silent close in dup2() is an implementation blemish.  Why not eliminate it?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
