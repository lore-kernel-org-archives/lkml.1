Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbZDAPSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbZDAPSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbZDAPSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:18:16 -0400
Received: from host64.cybernetics.com ([98.174.209.230]:1319 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbZDAPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:18:14 -0400
Message-ID: <49D385B2.3040909@cybernetics.com>
Date: Wed, 01 Apr 2009 11:18:10 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org, torvalds@linux-foundation.org,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, w@1wt.eu,
       rbranco@la.checkpoint.com, jake@lwn.net, eteo@redhat.com,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       dgilbert@interlog.com
Subject: Re: [patch 25/45] SCSI: sg: fix races during device removal
References: <1238544620.5000.5.camel@mulgrave.int.hansenpartnership.com>	<alpine.LFD.2.00.0903311717330.4130@localhost.localdomain>	<20090401011533.GO18394@sequoia.sous-sol.org> <20090401105413U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401105413U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 31 Mar 2009 18:15:33 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
>
>   
>> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
>>     
>>> On Wed, 1 Apr 2009, James Bottomley wrote:
>>>       
>>>> I think we could wait a bit to see if any issues turn up in 2.6.30
>>>> testing.  I think it should go in eventually, though.
>>>>         
>>> Sure, that sounds sane. But right now it has very little extra testing, so 
>>> wait with putting it into -stable at _least_ until after -rc1 release or 
>>> something?
>>>       
>> I'll drop it (meaning the three).  James can you resend after they've
>> withstood the test of time?
>>     
>
> I really want to push the patches as soon as possible. The bug that
> the 27/45 patch fixes has been for two months and I saw bug reports
> about it again and again:
>
> http://marc.info/?l=linux-kernel&m=123841463709919&w=2
>
>   
My two patches (25/45 and 26/45) fix very old problems, so there is no
rush to get them into -stable for their own sake.  However, Fujita's
patch (27/45) looks like it depends on my large patch (25/45), and it
fixes a regression present in 2.6.28 and 2.6.29.  So we have to weigh
the need to fix a regression that affects multiple people against the
chance of introducing new regressions.  Waiting until after 2.6.30-rc1
sounds reasonable to me, although I am not one of the people affected by
the regression fixed by Fujita's patch (since I am still using 2.6.27
-stable).

Another thing to consider is whether these patches should be included in
2.6.27 -stable.  Fujita's patch (27/45) shouldn't be necessary since
2.6.27 doesn't have the regression.  Omitting that patch removes the
dependency on my large patch (25/45), so we could question whether any
of these three patches should be included in 2.6.27.  As Linus points
out, my large patch is way above the official size limit for -stable,
but on the other hand, perhaps we could assume that "good enough for
2.6.28.x and 2.6.29.x" implies "good enough for 2.6.27.x".

Finally, I should point out that the effectiveness of "[patch 26/45]
SCSI: sg: fix races with ioctl(SG_IO)" depends on the changes to
sg_rq_end_io() made by "[patch 25/45] SCSI: sg: fix races during device
removal", so the smaller patch 26/45 should not be applied by itself
without the large patch 25/45.

Tony Battersby
Cybernetics

