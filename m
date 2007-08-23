Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbXHWIzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbXHWIzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 04:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbXHWIzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 04:55:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:27756 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbXHWIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 04:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LYGAAcCBo+P7lWGu8vIsL9Iwl9I5Xuxqi40wDb+tck3KBjiJBVKwl3CpZ/PmQMPZ+a50lxigLd5SXLUeRLxdx3BWdpPqxHiSh0fkINT+OwX5VkxEeGgWcm7m2K77FYP/8mNdwkFqpgFjUzQQwdWCz+JlYG+a05/kWYLC07T70Ms=
Message-ID: <6278d2220708230155j18248f2cr3cc697a7acbaa930@mail.gmail.com>
Date: Thu, 23 Aug 2007 09:55:36 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Richard Ballantyne" <richardballantyne@gmail.com>
Subject: Re: file system for solid state disks
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Aug, 07:00, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Aug 23 2007 01:01, Richard Ballantyne wrote:
> >What file system that is already in the linux kernel do people recommend
> >I use for my laptop that now contains a solid state disk?
>
> If I had to choose, the list of options seems to be:
>
> - logfs
>   [unmerged]
>
> - UBI layer with any fs you like
>   [just a guess]
>
> - UDF in Spared Flavor (mkudffs --media-type=cdrw --utf8)
>   [does not support ACLs/quotas]

Isn't it that with modern rotational wear-levelling, re-writing hot
blocks many times is not an issue, as they are internally moved around
anyway? So, using a journalled filesystem such as ext3 is still good
(robustness and maturity in mind). Due to lack of write buffering,
perhaps a wandering log (journal) filesystem would be more suitable
though? I use ext3 on my >35MB/s compact flash filesystem.

I can see there being advantage in selecting a filesystem which is
lower complexity due to no additional spatial optimisation complexity,
but those advantages do buy other efficiency (eg the Orlov allocator
reducing fragmentation, thus less overhead), right?

Also, it would be natural to employ 'elevator=none', but perhaps there
is a small advantage in holding a group of flash blocks 'ready' (like
SDRAM pages being selected on-chip for lower bus access latency) -
however this no longer holds when logical->physical remapping is
performed, so perhaps it's better without an elevator.

Clearly, benchmarks speak...but perhaps it would make sense to have
libata disable the elevator for the (compact) flash block device?

Daniel
-- 
Daniel J Blueman
