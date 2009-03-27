Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZC0Qt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZC0Qt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZC0Qtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:49:47 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:54419 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331AbZC0Qtq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:49:46 -0400
From: Frans Pop <elendil@planet.nl>
To: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Linux 2.6.29
Date: Fri, 27 Mar 2009 17:49:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <200903271435.23116.hpj@urpla.net>
In-reply-To: <200903271435.23116.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903271749.43762.elendil@planet.nl>
X-OriginalArrivalTime: 27 Mar 2009 16:49:44.0318 (UTC) FILETIME=[07D549E0:01C9AEFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Peter Jansen wrote:
> Am Dienstag, 24. März 2009 schrieb Linus Torvalds:
>> This obviously starts the merge window for 2.6.30, although as usual,
>> I'll probably wait a day or two before I start actively merging.
> 
> It would be very nice, if you could start with a commit to Makefile,
> that reflects the new series: e.g.:

If you have a git checkout, you can easily do this yourself:

git checkout -b 2.6.30-rc master
sed -i "/^SUBLEVEL/ s/29/30/; /^EXTRAVERSION/ s/$/ -rc0/" Makefile
git add Makefile
git commit -m "Mark as -rc0"

Then to get latest git head:

git checkout master
git pull
git rebase master 2.6.30-rc

When Linus releases -rc1, the rebase will signal a conflict on that commit 
and you can just 'git rebase --skip' it.

Instead of sed you can also just edit the Makefile of course, or you can 
go the other way and create a simple script that automatically increases 
the existing sublevel by 1. I just do this manually, given that it's only 
needed once per three months or so.

Using a branch is something I do anyway as I almost always have a few 
minor patches on top of git head for various reasons.

Cheers,
FJP
