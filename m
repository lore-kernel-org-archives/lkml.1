Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbZCPPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbZCPPBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbZCPPBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:01:05 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:36120 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756633AbZCPPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:01:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KeI+vSSEN9BEgpsyc8g9w8TuTghsUhbzIL4oAcgUxp/583PA1w0Qb6t6LyKfGo1wAgt/zlekv5P8UYu91EdcTvJ69k6OQVDdAVrVJmwcDFrAbCBexyYyeC8YaLVfrIA8qBVQK9LfoKlPj+nd6dLTbg8F3X3DD0j01KWqgczxZ0o=  ;
X-YMail-OSG: BF_xvXoVM1kocccEBPl0kwESHgOASNQJBhX0z6d5p5QyJBTvG4SYCBhdaQYozfRQcrwR3TtssImAcRnGxEvV9s.hTc.J0X4G4afh1TW8_bXsU9CKUlgTv6tItbNDuj9sYZK1pQwMDIzL62hAaqNqAz9bjl7bXURQtRQK41xwRzFCcs6AdxNDHHYVTT3jMA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate reclaim context (__GFP_NOFS), fix SLOB)
Date: Tue, 17 Mar 2009 02:00:52 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
References: <20090128135457.350751756@chello.nl> <200903162100.30029.nickpiggin@yahoo.com.au> <1237215129.3213.193.camel@calx>
In-Reply-To: <1237215129.3213.193.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903170200.53680.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009 01:52:09 Matt Mackall wrote:
> On Mon, 2009-03-16 at 21:00 +1100, Nick Piggin wrote:

> > This doesn't work because you have to hold the lock over the test
> > otherwise another thread can concurrently meddle with sp->units.
>
> Ahh, yes, I was glossing over that code because of the misleading
> comment. I was assuming this was the case where the object itself was a
> page, rather than object is the only allocation on the page.
>
> > For that matter my previous patch was buggy, aside from the obvious
> > that Ingo pointed out, because I unlocked before removing the page
> > from the freelist too.
> >
> > This should be pretty close to correct ;)
>
> Yes. Now the only question that remains is if we want to change a nearly
> negligible performance improvement for a nearly negligible size
> increase.

I'd let you decide that one. I very much doubt it would be noticable on
UP, however it might reduce interrupt hold times there. In case of
several CPUs case, it might give some small scalability improvement of
the lock.


