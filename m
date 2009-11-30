Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZK3RoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZK3RoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZK3RoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:44:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:3861 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZK3RoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KFsReH4+6DSi6IzpDyyj6pePCnB98AKxDqgtcD2eaWD466S72TESn6KeJyExr1cEHD
         U55XDDPsVkyI+ngpyct5fPj8+jktE7A9Pe5K6G3Sj7fEIy0eFqtSIs67UzYUClx7+nK0
         e+oDsimV3Fju+Su/pcDcsTC4Y6I9mA66H9eVk=
MIME-Version: 1.0
In-Reply-To: <4B13FA4E.1070901@zytor.com>
References: <a36005b50911300837s6fe4da73s973ccbe7401b9989@mail.gmail.com> 
	<4B13FA4E.1070901@zytor.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 30 Nov 2009 09:43:49 -0800
Message-ID: <a36005b50911300943i947c91fva2b93f5f067665a1@mail.gmail.com>
Subject: Re: using kernel headers in libc headers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 09:01, H. Peter Anvin <hpa@zytor.com> wrote:
> A better way is to factor out subsets; if <linux/sched.h> has too many
> things, we can break out the POSIX parts into <linux/sched_posix.h> or
> (certainly better if we have more than one of these)
> <linux/sched/posix.h> which can also be included by <linux/sched.h>.

This is at least as undesirable.

First, there can be several different of those.  E.g., there are
different levels of POSIX compliance and the number of growing.  There
are also conditions like

  if POSIX version > 2001012 || GNU source

How do you express this?

Second, it makes it hard to impossible for developers to use the
headers as part of the system documentation.  Many people (me
included) look at headers and the included comments.  With your scheme
the set of definitions (e.g., SCHED_* macros) might be spread out over
several different headers.  Currently they are all nicely group (in
the kernel and libc headers) and people can see what is available.


None of the #ifdefs should interfere with kernel compilation.  It can
be easily arranged so that when compiling the kernel all these macros
are automatically set.
