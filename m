Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZKEGnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZKEGnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZKEGnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:43:11 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:58861 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZKEGnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OFL0igsCO5e8sxnMzyBuRmH+EYgd95ULxbA79lsO7H8Ff1iV+koIuhg17FQaMSd4qB
         j85VAOj4mRDk84GCtdBAGjuNMX8tU+cm7FIoQwpYTKdej3vD7hUhXlk2b70n2/YQfPIt
         eVX5cadDEqrIOhQPBEMMt6afRtcBusURRUql8=
MIME-Version: 1.0
In-Reply-To: <200911042206.54801.elendil@planet.nl>
References: <1257315285-6782-1-git-send-email-akinobu.mita@gmail.com>
	 <200911042206.54801.elendil@planet.nl>
Date: Thu, 5 Nov 2009 15:43:16 +0900
Message-ID: <961aa3350911042243n3cf78cadtf45fb33da35a0f3a@mail.gmail.com>
Subject: Re: [PATCH] kbuild: let make O=dir rpm-pkg fail
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/5 Frans Pop <elendil@planet.nl>:
> On Wednesday 04 November 2009, Akinobu Mita wrote:
>> make rpm-pkg with setting KBUILD_OUTPUT is not possible and
>> it will print the good message since the commit
>> db9038c89d129383a9db2afcb72b504fe54f6edf
>>
>> $ KBUILD_OUTPUT=dir make rpm-pkg
>> ...
>> Building source + binary RPM is not possible outside the
>> kernel source tree. Don't set KBUILD_OUTPUT, or use the
>> binrpm-pkg target instead.
>> ...
>>
>> make O=dir should have the same effect of KBUILD_OUTPUT, but
>> it won't print that message.
>>
>> This fixes it by exporting KBUILD_OUTPUT if O= is set so that
>> the rpm-pkg target in scripts/package/Makefile can find it.
>
> Looks good to me. I suspect this will also fix the open question that I had
> when I submitted the patch you refer to:
> <quote>
> One open issue is that the following commands should IIUC be identical,
> but the second one does not work:
> - KBUILD_OUTPUT=../builds/amd64 make -j4 binrpm-pkg
> - make -j4 O=../builds/amd64 binrpm-pkg
>
> AFAICT the root Makefile is supposed to set KBUILD_OUTPUT based on O=, but
> that is not visible when the lines within the binrpm-pkg target are
> executed.
> My make foo was not strong enough to debug this.
> </quote>

make binrpm-pkg with O= works without this patch on my system
(CentOS5 i386). So I did not mention about it in the patch description.

> I also suspect that the use of O= is currently equally broken for the
> deb-pkg target (I know setting KBUILD_OUTPUT does work) and that this
> patch will fix that as well.

I don't have debian based system and I can't test deb-pkg now.
But I hope it works, too.
