Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbXIOSub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbXIOSub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXIOSuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:50:24 -0400
Received: from smtp120.sbc.mail.re3.yahoo.com ([66.196.96.93]:28403 "HELO
	smtp120.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751452AbXIOSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:50:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=yJe5lnn/pJ7recZUpICpLKS1RO8fq0kiLKzhgjWrfVVFxQQl7DNds8VnMLcR4lAxDmha3wFoShqmUGhsNRq8T/qamH3+ActLczovBniF5ll2iQ4XZTZKsqK5zpPMIUhFeIC80ZiusxH4p+5N4duMKJfcFAAT4HrxTtmPsXF8tpI=  ;
X-YMail-OSG: e.tritgVM1mSphSLrmjxaMrdSkYIC0mJMu3Nf.xPVotpp3Psnao_1.494o.KDBZX4Hv8A_vdkw--
Date: Sat, 15 Sep 2007 11:50:21 -0700
From: David Brownell <david-b@pacbell.net>
To: cebbert@redhat.com, akpm@linux-foundation.org
Subject: Re: Two identical entries for "rtc" in /proc/devices
Cc: linux-kernel@vger.kernel.org
References: <46E07DDA.2040907@redhat.com>
 <20070915004421.33d552d3.akpm@linux-foundation.org>
In-Reply-To: <20070915004421.33d552d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070915185020.16BB51F9EAA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 06 Sep 2007 18:23:22 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:
>
> > # ls -li
> > total 0
> > 4026532007 -r--r--r-- 1 root root 0 Sep  6 18:18 nvram
> > 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> > 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> > 4026532056 -rw-r--r-- 1 root root 0 Sep  6 18:18 snd-page-alloc
>
> Next -mm has
>
> procfs-detect-duplicate-names.patch
> procfs-detect-duplicate-names-fix.patch
> procfs-detect-duplicate-names-fix-fix-2.patch
>
> which will at least tell us who the second offender is.

Semes pretty clear that this must be procfs itself...
when a filesystem sees a name in a directory, it should
refuse to make another file with the same name.  And it
should *never* reuse inode numbers...


