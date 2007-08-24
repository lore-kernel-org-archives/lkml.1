Return-Path: <linux-kernel-owner+w=401wt.eu-S933627AbXHXAhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627AbXHXAhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764565AbXHXAhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:37:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:11426 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764058AbXHXAhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vm+E3e0ZEfR1zhh+m7DNmEAwhzNml9bAzHmWAX/MWu8uOVrqoQ1XmgnMl16auaFLL6VqzOcn1J7UpQi7SjEWHtoFiZckZK5sJeXnJKg4p9fYrwJ+wG4HkxXFnK9PANDhDpDh1pJNQ7cXCJtlWXsWjtWi9hibeUfJgi1Q3b+VFKM=
Message-ID: <7b9198260708231737r5709788bmec4d294361b21a4a@mail.gmail.com>
Date: Fri, 24 Aug 2007 01:37:40 +0100
From: "Tom Spink" <tspink@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
In-Reply-To: <7b9198260708231737t33923ec6yde48bb1338a6fa70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	 <46C4BC46.7000305@redhat.com>
	 <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
	 <46C9A867.6090509@redhat.com>
	 <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
	 <m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com>
	 <m34pipgbyt.fsf@maximus.localdomain>
	 <7b9198260708231737t33923ec6yde48bb1338a6fa70@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Chris Snook <csnook@redhat.com> writes:
>
> > Wrapping a single printk that's unrelated to debugging in an #ifdef
> > CONFIG_* or a sysctl strikes me as abuse of those configuration
> > facilities.
>
> Abuse, probably not (if a thing is required on one system and must
> not be on another, it has to be configurable). If the printk is
> a good idea... IMHO hardly, at best. We don't warn about trying to
> write to /vmlinuz after all.
>
> ulimit/pam_limits should fix the (IMHO nonexistent) problem nicely.
> One has to plug all the holes, though (e.g. $HOME/.forward).
> --
> Krzysztof Halasa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi,

I agree with Chris on this point, it seems like this sort of detection
(and reporting) should be a job for a user-space daemon, rather than
polluting kernel code (and logs) with warning messages of this sort...
I don't think the type of warning this patch yields is appropriate for
kernel logs, nor do I think the kernel should be the entity to decide
that this warning should be given.

It _feels_ wrong.

--
Regards,
Tom Spink
University of Edinburgh
