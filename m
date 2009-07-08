Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZGHFPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZGHFPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZGHFPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:15:22 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:48409 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZGHFPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M6Q60vd+RYDUMxCFgu7FqORQJC/totndUSFRcsHW1TLIJEmydtbuuiUw3kMmhyUQRQ
         iuYPL0Ye6IKsW0glAi88IbKpvaDoAetd1GCMj52ZXvbKM1q0VsZLWmJuZ8vPeZ3gUaH8
         5vnrtsWyTo6rKjIn3i4d4Uae/vCN6vuKCE+pg=
Date: Wed, 8 Jul 2009 13:15:15 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Minchan Kim <minchan.kim@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: OOM killer in 2.6.31-rc2
Message-ID: <20090708051515.GA17156@localhost>
References: <200907061056.00229.gene.heskett@verizon.net> <200907071057.31152.gene.heskett@verizon.net> <20090708021708.GA10481@localhost> <200907072342.07822.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907072342.07822.gene.heskett@verizon.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:42:07PM -0400, Gene Heskett wrote:
> On Tuesday 07 July 2009, Wu Fengguang wrote:
> >On Tue, Jul 07, 2009 at 10:57:30PM +0800, Gene Heskett wrote:
> >> On Tuesday 07 July 2009, Wu Fengguang wrote:
> >> >On Mon, Jul 06, 2009 at 10:56:00AM -0400, Gene Heskett wrote:
> >> >> Greetings all;
> [...]
> >> >
> >> >Normal zone is absent in the above lines.
> >>
> >> Is this a .config issue?
> >
> >At least CONFIG_HIGHMEM64G is not necessary, could try disabling it.
> 
> I have in a rebuild of this 2.6.30.1 kernel, but ISTR I enabled that because 
> it was only using 3G of the 4G of ram in this box, an AMD-64 Phenom, 4 cores, 
> 4G ram.  But I haven't rebooted to it yet.  Next good excuse.  See below... :)

I guess you can only use 3G ram because there is a big memory hole.
Your HighMem zone spanned 951810 pages, 813013 of which is present.
So it's not quite accurate for the OOM message "951810 pages HighMem"
to report the spanned pages.

Your Normal zone has 221994 present pages, while the OOM message shows
"slab:206505", which indicates that the OOM is caused by too much
slab pages(they cannot be allocated from HighMem zone).

I guess your near 800MB slab cache is somehow under scanned.

Thanks,
Fengguang
