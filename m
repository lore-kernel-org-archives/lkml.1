Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYG2NRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYG2NRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYG2NRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:17:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYG2NRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:17:32 -0400
Date: Tue, 29 Jul 2008 09:16:50 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Message-ID: <20080729091650.0ddca3d8@bree.surriel.com>
In-Reply-To: <20080729220012.F192.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080724222510.3bbbbedc@bree.surriel.com>
	<20080729220012.F192.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 22:04:16 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> >   TEST 1: dd if=/dev/sda of=/dev/null bs=1M
> > 
> > kernel  speed    swap used
> > 
> > 2.6.26  111MB/s  500kB
> > -mm     110MB/s  59MB     (ouch, system noticably slower)
> > noforce	111MB/s  128kB
> > stream  108MB/s  0        (slight regression, not sure why yet)
> 
> I tried to reproduce it, my ia64 result was
> 
> kernel                   speed        swap used
> 2.6.26-rc8               49.8MB/s     1M
> 2.6.26-rc8-mm1           47.6MB/s     168M
> -mm with above two patch 50.2MB/s     0
> 
> 
> So, I think it isn't regression.

Agreed.  It looked like it, but once I changed the cpuspeed
governor from ondemand to performance, I saw that it had to
be an artifact of something else.

Getting rid of the swap use from a linear IO is the important
part.

-- 
All rights reversed.
