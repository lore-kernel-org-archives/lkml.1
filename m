Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbYD2Rp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbYD2Rp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbYD2Rpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:45:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:28013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbYD2Rpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jggme9kVaozXqoYI+p+VgQD3ZXRftClBdJaLUIkvmzfuJ1oxyEaNmjLBIYpiOBjMg1JSGzFs3wTlIaPMuDjfTbfeEdBKkPEI4xz37gbL0fdtTOUIueQpnK1ktSkGtgxKEokgwIY5eBYzOerJzw6MYrbjRgMkI4CVbXWtXHLJBrY=
Message-ID: <e2e108260804291045k353e2ed0r4b14ba4820f6f156@mail.gmail.com>
Date: Tue, 29 Apr 2008 19:45:43 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <1209488643.6433.14.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
	 <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
	 <1209482101.13978.91.camel@twins>
	 <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
	 <1209485739.13978.96.camel@twins>
	 <e2e108260804290929l3c7a6a07nddc18512abb9e6ed@mail.gmail.com>
	 <1209488643.6433.14.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 7:04 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  I think the critical part is:
>
>  > It really is invalid when considered against write locks.
>
>  Aside from that it just states that inversion of lock order will be
>  treated as invalid - even for read locks.

Inversion of recursive reader locks can't trigger a deadlock, even
when considered against write locks, as long as the rules are followed
I posted earlier. I invite anyone to come up with an example that
proves me wrong.

Let's return to the starting point of this discussion. The patch at
the start of this thread forbids to invert the lock order of reader
locks. Why to forbid this if it can't trigger a deadlock ? At least in
user space code, it's quite easy to trigger such inversion. In
sufficiently complex code where functions call other functions while
holding a reader lock, reader lock inversion can be hard to avoid.

Bart.
