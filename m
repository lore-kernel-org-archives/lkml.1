Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZF3MK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZF3MK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZF3MKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:10:16 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43140 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZF3MKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wH89OxbicSGrb7AkwAFxdPszSMfQpkxD41FPJ0vQ7N9w1xonX8nFg7rW8ZMkj6bC0O
         XjLvtc5e82yI67GfNj3V5YnL+vX2+1kEIs+wcgOMN5Zq8lwWWrdPw6Q+HNAgVoFLGXuM
         T5YKxcrQ2ZqfjjLZMp0TN98NhIgV5xb2WVxoA=
MIME-Version: 1.0
In-Reply-To: <20090629232733.7ae52b7f@lxorguk.ukuu.org.uk>
References: <200906300003.39440.vda.linux@googlemail.com>
	 <20090629232733.7ae52b7f@lxorguk.ukuu.org.uk>
Date: Tue, 30 Jun 2009 14:10:15 +0200
Message-ID: <1158166a0906300510w5b03adb9k7368a049a2bec263@mail.gmail.com>
Subject: Re: [PATCH] make execve(NULL) re-execute current binary
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 12:27 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 30 Jun 2009 00:03:39 +0200
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
>
>> Hi Al, Andrew, folks,
>>
>> This is a version 2 of re-execution patch.
>>
>> I replaced hardcoded "/proc/self/exe" with execve(NULL)
>
> So you add hacks to sys_execve, which means hacks on every system that
> doesn't need it

Yes.

> and also undefined behaviour if you use the feature when
> it isn't present.

The behavior of execve(NULL) is not undefined. It returns EFAULT.
The idea was that application will do:

/* Try traditional way */
execv("/proc/self/exe", argv);

/* Try Linux specific extension (only new kernels have it) */
execv(NULL, argv);

/* Give up */
printf("Can't re-exec myself\n");
exit(1);

which is safe on older kernels as well.

> Please implement sys_reexec() as was suggested before.

Ok.

--
vda
