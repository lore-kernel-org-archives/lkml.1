Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbXBDLKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbXBDLKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 06:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXBDLKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 06:10:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:30242 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXBDLKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 06:10:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gnYXkvwbhWDCGJ+Zwp8ZbxERHnCZfw18e2H4ZOTo4sISq4ki6jmacxmFjR7yaimnCXWUmlfvUA6vvv2H6F+AifTW7vJeFslrVjU8cHxPnjOcl3oO9oFRCfjHKM+qK1hRp8N/ISMafmQVJGAzUe/AlGWHDyELMugDd/NWas/ahDM=
Message-ID: <b681c62b0702040310g766048ci1af89174c4cb9d07@mail.gmail.com>
Date: Sun, 4 Feb 2007 16:40:09 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: davids@webmaster.com
Subject: Re: Excessive printks increase top mem usage?
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b681c62b0702030411x2a61f453t4e2997ce866417e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b681c62b0701250523w14f0d0efl78b1ab3be7693c31@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKKEFLBCAC.davids@webmaster.com>
	 <b681c62b0702030411x2a61f453t4e2997ce866417e6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cc to lkml

On 2/3/07, yogeshwar sonawane <yogyas@gmail.com> wrote:
> Thanks for the explanation.
>
> On 1/26/07, David Schwartz <davids@webmaster.com> wrote:
> >
> > > On 1/25/07, yogeshwar sonawane <yogyas@gmail.com> wrote:
> > > > Hi all,
> > > > I am running a user application which will just open/close my driver
> > > > (simple one, empty functions with only printks) infinitely.
> > > > A massive use of printk can slow down the system noticeably OR it can
> > > > affect some time calculations.
> > > > Apart from this, it was increasing top mem usage also. After closing
> > > > the application, the memory consumption was not coming down(not
> > > > freeing mem). Is this the expected behaviour? OR i am missing
> > > > something?
> > > >
> > > > Can anybody help me in guiding the reason for this? Any help/links plz.
> > > >
> > > > Thanks in advance,
> > > > Yogeshwar
> >
> > What does "increased top mem usage" mean? You have given no reason to
> > suggest that there's anything unusual about this.
> >
> > Here's one theory: Some program is writing these kernel messages to a file.
> > Because some other process might come and read that file later, the kernel
> > keeps copies of the file data in memory.
> >
> > The kernel sees no advantage in having memory free. Free memory is memory
> > that's not doing any good. Better to keep data in memory that might be
> > useful later. We can always free the memory later if (and only if) we have
> > something better to do with it.
>
> One more thing:-
> If i want to allocate physical memory using __get_free_pages, and
> there is no free mem available, then kernel will release mem used by
> file data & use it for my request. Is this correct?
> I just tried similar thing. My test machine has 4GB RAM. On my test
> machine, as explained in my previous mail, i was printing excessive
> messages. Due to this top was showing mem usage aroung 1.9GB. Then i
> tried allocation of 4MB phy mem(using __get_free_pages) iteratively
> till it fails. The allocation succeeded upto @ 4-1.9 GB. I thought
> that some mem from 1.9 GB will be released for phy mem allocation. But
> it didn't. Such runs were tried 3-4 times. But consistently it
> succeeded upto 4-1.9GB. So is this normal ?
>
> regards,
> Yogeshwar
>
> >
> > DS
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
