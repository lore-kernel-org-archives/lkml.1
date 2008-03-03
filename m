Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYCCNF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYCCNF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYCCNFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:05:20 -0500
Received: from n4a.bullet.mail.tp2.yahoo.com ([203.188.202.98]:33223 "HELO
	n4a.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751566AbYCCNFT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:05:19 -0500
X-Yahoo-Newman-Id: 403706.68203.bm@omp407.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3DWjaLS9q8qNg9UsWi5dx/XmDsXgo51nDIOs82l89icUrdfuJvUZ4svkIQ7fM15aIUZYh/z/OZjpu68J5AqJxr+dtvTwdpioajh2J6mUDRdrBYIxRDVD2e3UhkYmCbr0V6w3OHOytOk/HE9z6tsk20hyPYfKbWuy0pPhXQia0/o=  ;
X-YMail-OSG: wS2FLssVM1mQzC0NE9fzP8EUsyf59MNR1JzW.9ntyLeaCZBYimNzHZW4pneofd45XTeD8JTwqg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Diego Calleja <diegocg@gmail.com>
Subject: Re: Performance versus FreeBSD 7.0
Date: Tue, 4 Mar 2008 00:04:51 +1100
User-Agent: KMail/1.9.5
Cc: "Stephen Cuppett" <cuppett@gmail.com>, linux-kernel@vger.kernel.org
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com> <20080229155408.116fa5a1.diegocg@gmail.com>
In-Reply-To: <20080229155408.116fa5a1.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803040004.52299.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 01:54, Diego Calleja wrote:
> El Fri, 29 Feb 2008 08:38:00 -0500, "Stephen Cuppett" <cuppett@gmail.com> 
escribió:
> > loads and 1500% at high loads. When compared with the best performing
> > Linux kernel (2.6.22 or 2.6.24) performance is 15% better. Results are
>
> There has been some performance problems with sysbench performance in linux
> which made it slower than freebsd, there were some patches to speed things
> up, not sure if they have been merged.

There definitely were performance problems with threaded malloc/free
in the Linux kernel and glibc. Fixes have been merged in both packages,
and AFAIK the FreeBSD guys tested with those fixes in place.

I think these were never really run into before in part due to MySQL's
unscalable heap design makes it not scale well on higher numbers of
CPUs anyway, and also made the malloc problems more pronounced (ie.
they added a bit to the contention of the single heap lock, which is
the big killer here).

But it was very nice to be made aware of the problem and be able to
improve it.


> Myself I find fun that they look at Linux as the Leader That Must Be
> Surpassed. All the performance highlights of freebsd 7.0 are things that
> linux already did some years ago.

I don't know very much about FreeBSD nor have verified the results
for myself. But to their credit they seem to have done quite well at
least on the smaller end of the scale.

