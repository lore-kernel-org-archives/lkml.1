Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYFKGPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYFKGPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFKGPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:15:38 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:26112 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752249AbYFKGPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:15:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YseguUFEEo5ht7Qw2mInCsbfjb9BDPitVNmhN2Jy/AFeT9nnX7C+DB0tteiqctRe7oRWtuTbAA2avXWiyjtGukKrq0KzgWh9nRqe8XoXq/VZRecMFeHLxK20ZxRqIJAM/R2w+NKWQKR95pjbhOpi7cHHjfGj4O5uwx9Kvx2X3Bw=  ;
X-YMail-OSG: hFAol0wVM1kMJ1z6FYphmM.dOiNqHp3Iqyf.niy_Ojp2JQL86VVOcBNJI2maKj18CzFySMZZgcpU8VYq_EnAKhApD2VVO6bQbRrsl6MAHwU84JYzznWKg5NJOl_RuSyYr7I-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Date: Wed, 11 Jun 2008 16:11:47 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <20080611060029.GA5011@martell.zuzino.mipt.ru>
In-Reply-To: <20080611060029.GA5011@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111611.47402.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 16:00, Alexey Dobriyan wrote:
> On Mon, Jun 09, 2008 at 10:31:45PM -0700, Andrew Morton wrote:
> > - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
> >   vmscan.c bug which would have prevented testing of the other vmscan.c
> >   bugs^Wchanges.
>
> OOM condition happened with 1G free swap.

Seems like you've got little or no anon pages left, so 1GB free swap
is no problem (nothing left to page out).


> 4G RAM, 1G swap partition, normally LTP survives during much, much higher
> load.

I would hope it is not a memory leak (which might point to lockless
pagecache). It doesn't look like it because there is still lots of
inactive file pages, so that points to the page reclaim changes
(which is not to say page reclaim changes couldn't cause a memory
leak themselves).

Curious: if you kill off all the LTP tests after the OOM condition,
what does your /proc/meminfo look like before and after running
sync ; echo 3 > /proc/sys/vm/drop_caches
