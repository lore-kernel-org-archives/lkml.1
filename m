Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbXI0Rep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbXI0Rep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbXI0Reg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:34:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:36588 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbXI0Ref (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BNej8A1ZrXEbvIIroDI7S0PcT4qnbWtIY0jG9VHOoXXqBPXY87NdY7n17nIr7UXRSLX3s6kLQkQH/b1mspGs2T6TT2zDsyZX85jRkkuEeMUAgYpbM5TBZjDsbycWe0I30nog94P5vRFqonJHucpQEEuoNi27QQy+KZSEkHLT07g=
Message-ID: <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
Date: Thu, 27 Sep 2007 19:34:34 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Tejun Heo" <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46FB4CB3.3090004@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>
	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
	 <46FB4CB3.3090004@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/27/07, Jeff Garzik <jeff@garzik.org> wrote:
> Torsten Kaiser wrote:
> > I compared the dmesg form good and bad boots with -rc7-mm1 but could
> > not see any difference, so do you think that these additional
> > diagnostics could show a difference?
> > Or could you suggest any other debugging options I should try?
>
> I think since its a reproducible problem, I think it's easiest to get
> you straight to git-bisect.  In this case, that would be

Sorry, but I don't think that will work.
It seems that I am able to reproduce the bug, but not reliable. And my
current best guess to make it happen involves the step "leaf the
computer powered off for 8 hours".
I estimate that even with the 8 hour pause only at ~50% of the boots
one drive fails. So I have no safe point to mark a bisect step as
'good'.

>         a) start with a known good point (v2.6.22? v2.6.23?) and
>         known bad point (HEAD, aka the most recent commit in
>         libata-dev.git#upstream)

Known good is for me 2.6.23-rc3-mm1, the first known bad is 2.6.23-rc4-mm1.
I will try to look at the diff between these revisions some more, but
the change in sata_sil24.c looked like a perfect match for the
symptoms I was seeing.

What I just noticed, as I wanted two re-add the drive to the RAID:
This time it was not sda, but sdb that was kicked. But otherwise the
errors are perfectly identical.

I will try to make a 2.6.23-rc3.5-mm1 to narrow it down some more...

Torsten
