Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZAMXg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZAMXg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZAMXgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:36:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42184 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZAMXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:36:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Fk9CrVda4NRA9VMA16OPR1adUvXeFpkLERM+Ble8nJf9/4/TVxUp62R+6RQdDIw+Wb
         ik8RtfJcrvljO+fadBcTK12d0EPr6x3l9fSly7pLLuc/paOsa/dXG84nYbfW91X43/ou
         8yi+9lwEP0kT3W2ZBD+zOJgnay1oBtneyHpS4=
Message-ID: <cfd18e0f0901131536v30d01881uec31e08000be883c@mail.gmail.com>
Date: Wed, 14 Jan 2009 12:36:44 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Cc: roland@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       vegard.nossum@gmail.com, linux-man@vger.kernel.org, stable@kernel.org
In-Reply-To: <20090113152457.0d7685ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>
	 <cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>
	 <20090113152457.0d7685ad.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:24 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 Jan 2009 12:14:20 +1300
> "Michael Kerrisk" <mtk.manpages@googlemail.com> wrote:
>
>> On Wed, Jan 14, 2009 at 11:49 AM, Roland McGrath <roland@redhat.com> wrote:
>> > It's always been invalid to call waitid() with a NULL pointer.  It was an
>> > oversight that it was allowed (and acts like a wait4() call instead).
>> >
>> > Signed-off-by: Roland McGrath <roland@redhat.com>
>>
>> Modulo the observation that this change will break any Linux-specific
>> application that violate POSIX.1's requirement that infop not be NULL
>> (*), and rely on the existing Linux behavior for
>> waitd(idtype,id,NULL,options):
>>
>
> Well yes.  waitid() has been in there since 2.6.9.  I assume that it
> has had this wait4-emulation mode for that amount of time as well?

AFIACS, yes.

>> (*) It seems unlikely that such applications exist, and we really
>> should make this change for POSIX.1 conformance.
>
> Well, we might get away with it.  But formally speaking, we should live
> with our Linux-specific screwup.

Yes, tricky.  On the one hand, we shouldn't break the ABI.  On the
other hand, POSIX.1 is explicit in disallowing the case that would
lead the ABI change made by this patch.  (For what it is worth, the
man page was released at pretty much the same time as the syscall, and
has always documented that the return value on success was 0, and
Vegard was the first person to report this case that deviated from the
doc.)

> If we _are_ going to make this change then we should merge it as far
> back in -stable as we can, to reduce the risk that people will develop
> applications on kernel version A only to have then behave differently
> on version B.

Ack.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
