Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYG2UGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYG2UGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYG2UGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:06:10 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21076 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752062AbYG2UGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:06:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eaSMrLiILhXSoiNa60nB1i511QwCIVHj65mlZ81dyBc7dWYZsXLR8psIjEiB1XVOCwMEhNxGfTEHmqMohniwPv5d2eLwdsH+Qc62D0u1oQagnYbfqVgLOXL9aMfsysSWEed9lbvwFLon5QaNFqSyTr7pbQY8U8DYqpIdh/3qeIg=  ;
X-YMail-OSG: p_PO2UEVM1m1H1qYmJ5_fYOVtV1GWZVmnIrz.XlOC54AUL5XfUQvVL3hlC9NS_fY0d6OSicSXJ4sGQ2Ny9xwN1rAHV4OqI_MsmXnLLmcGg50CmiePzFXjYjzVgj51OWzjvE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [patch 2.6.26-git] /dev/hpet - fixes and cleanup
Date: Tue, 29 Jul 2008 12:46:25 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <200807280127.22060.david-b@pacbell.net> <488D8D16.7010502@ladisch.de>
In-Reply-To: <488D8D16.7010502@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291246.26156.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Clemens Ladisch wrote:
> David Brownell wrote:
> > Oh ... I see.  It's called write_counter() but doesn't
> > actually write the counter.  Likewise, read_counter() is
> > not actually reading the counter.  Gaack ...
> 
> A more correct name would be something like
> write_a_register_that_has_the_same_size_as_a_counter_register().

writel() would be my choice ... :)

I don't think anything in that code really needs to modify the
upper 32 bits of those registers.  And nothing except the ia64
HPET clocksource needs to read them either.

 
> I'm hoping that I can deprecate and delete much of this code without
> having to clean it up first.

I'm not sure how practical that goal is, but I agree that there
seems to be no point to /dev/hpet ... certainly, you could start
by deprecating it and making sure distroes don't enable it.


> > Any comments on the rest?
> 
> Looks fine.  I would have preferred a series of smaller patches, but my
> feelings on this are not strong enough to split it myself or to ask you
> to do it.

OK, I'll send along the updated patch (against 2.6.27-rc1).

- Dave
