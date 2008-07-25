Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYGYTzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYGYTzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYGYTzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:55:38 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:45439 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943AbYGYTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:55:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VEUM0ZBLzEICN3UAKfV0vP7SwiKtg3kT8waRiIbGsx9f1psJE5flZN4LBFuZzUdtQV9ga+ItnYnfSwajUdJGQOEh3YRYcJT4c+PbltjEgfW59Xl1Pfe7Ixn5eBpgFAvCzXdHS9gdBfhO6YEUGJUy3uW2/fxr8QbqBPoBvGTGadk=  ;
X-YMail-OSG: M7aEhrQVM1ktrdq0MMxY16OBdoQ9UC7j3HHfT7xe7oNpOP3QQvtfszTxa47AWBM56d54MONSyb14hyM4xcjaKXC8zt285L_fDgV0IX6PfGDjssaIavkcj4NdmO53R3JRHz4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [patch 2.6.26] /dev/hpet - fixes and cleanup
Date: Fri, 25 Jul 2008 12:55:35 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <200807230912.49850.david-b@pacbell.net> <4888691D.5090307@ladisch.de>
In-Reply-To: <4888691D.5090307@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251255.35675.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Clemens Ladisch wrote:
> David Brownell wrote:

> > > This seems to be the only part of the userspace interface that is
> > > used in practice.  Because of the availability of POSIX timers, it might
> > > make sense to deprecate the HPET ioctl interface.
> >
> > I'll leave that part up to someone else.  If POSIX timers
> > are a sufficient userspace interface, great ... then that
> > mmap son't really be needed either!
> 
> The idea is to be able to get a high-precision timer value without doing
> a syscall.  (Whether the syscall overhead actually matters in a specific
> application is another question.)

On x86_64 the vsyscall stuff should kick in for gettimeofday()
when HPET is in use, eliminating the need for /dev/hpet mmapping.

I don't really know vsyscalls ... but if that could be done on
i386 systems, the last argument for /dev/hpet would seem gone...
