Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZJBWOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZJBWOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZJBWOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:14:25 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:39461 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZJBWOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p8Q+V8F5rFLOqvh3oakiE+Ho6RE/tzhM7ob39dYJeZTFlZL0J1Ht6yglu4XiIYABUj
         i7PZ2eV/W2Dvq78a0K4TSSLd6DmOBCas9rS37H+TuPgXQ0G65/q3It1hMhEdydWz9PAC
         oa+8r8ohI3/3UgfDAXqdKYUyei6sLaft+txp0=
MIME-Version: 1.0
In-Reply-To: <20091002195815.GE4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	 <20091002124921.GA4494@redhat.com>
	 <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	 <1254497520.10392.11.camel@marge.simson.net>
	 <20091002154020.GC4494@redhat.com>
	 <12774.1254502217@turing-police.cc.vt.edu>
	 <20091002195815.GE4494@redhat.com>
Date: Sat, 3 Oct 2009 00:14:28 +0200
Message-ID: <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 9:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Oct 02, 2009 at 12:50:17PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:
>>
>> Umm... I got petabytes of hardware RAID across the hall that very definitely
>> *is* rotating.  Did you mean "SSD and disk systems with big honking caches
>> that cover up the rotation"?  Because "RAID" and "big honking caches" are
>> not *quite* the same thing, and I can just see that corner case coming out
>> to bite somebody on the ass...
>>
>
> I guess both. The systems which have big caches and cover up for rotation,
> we probably need not idle for seeky process. An in case of big hardware
> RAID, having multiple rotating disks, instead of idling and keeping rest
> of the disks free, we probably are better off dispatching requests from
> next queue (hoping it is going to a different disk altogether).

In fact I think that the 'rotating' flag name is misleading.
All the checks we are doing are actually checking if the device truly
supports multiple parallel operations, and this feature is shared by
hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
NCQ-enabled SATA disk.

If we really wanted a "seek is cheap" flag, we could measure seek time
in the io-scheduler itself, but in the current code base we don't have
it used in this meaning anywhere.

Thanks,
Corrado

>
> Thanks
> Vivek
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
