Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZANBjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZANBjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZANBjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:39:13 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:48654 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZANBjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=K0mjMAlMFN1OXsNG2tFWflYNV896+Gbrkf5couGmV33mMNxdiZO2nA54ViZiLmvLKx
         f07LTacutZlbqpcjIge6+9WR7T/PUU3s8vZy7KrQGI3qxFx3f4bRlqKUVhOmBwgnGLzE
         GMIDCkyd/aw5qwDs/Cm3Nr6PYB6puR7Cm7SSA=
Message-ID: <cfd18e0f0901131739v5119271flc28b5531604e682@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:39:09 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Cc: "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901131655040.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain>
	 <cfd18e0f0901131653y76a827b5i906fadce63ada56b@mail.gmail.com>
	 <alpine.LFD.2.00.0901131655040.6528@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 1:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 14 Jan 2009, Michael Kerrisk wrote:
>>
>> It has zero downside for *us*.  But it is yet another example of Linux
>> littering the Unix landscape with unnecessary inconsistencies that
>> application writers must deal with.
>
> Bah. Not so. It matters not at all if you try to write portable code.
>
> Linux has extensions.

This a behavior that was unintended by the implementer, wasn't
requested by application writers, isn't present on other Unix systems,
and isn't specified by the standards.

It isn't an extension.  It's an accident.

And the fact that such accidents happen more often than necessary is
the real problem, rather than the fact that this API in particular is
inconsistent with expectations.

> Deal with it. We have literally _thousands_ of
> things that work on Linux but not on other OS's. The fact is, you can't
> just recompile and assume something works, and waitid() has absolutely
> nothing to do with it.
>
>> Well, POSIX.1-2001 is fairly clear:
>>
>>       The  application shall ensure that the infop argument points to
>>       a siginfo_t structure.
>
> Right. So the application should do that, and Linux does the right thing.
> Problem solved.

Right.  And this fact is why, while I incline to think we should fix
the interface, I don't feel strongly about it.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
