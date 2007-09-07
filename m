Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbXIHKeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbXIHKeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXIHKei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:34:38 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39556 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751156AbXIHKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:34:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GQOHFOy8MrSuetwshZobxtS/zWiVoHseW59uK0SEwiMrHWzIZ64XCxtcqiCcjHyhYSBh691Jo6ZjIu8Vvlrn2xdicc5FepMcWHd16C3ZpkY3NlY0N/yIoYguWPhmd7OanAPsskaACqIIz92Lu7dx/jUYZw27KMvbD8EeGhjgPKw=  ;
X-YMail-OSG: IBo0pm0VM1kdvm59v5f4z0I_32PXiDPxhziO36xtjUU.b9B6iQDa.v3sf1ptaxS_bv2Tsy9_BA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@suse.de>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 06:32:05 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709080557.36021.nickpiggin@yahoo.com.au> <200709081219.43662.ak@suse.de>
In-Reply-To: <200709081219.43662.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080632.05389.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 20:19, Andi Kleen wrote:
> On Friday 07 September 2007 21:57:35 Nick Piggin wrote:
> > > > Anyway, the lfence should be able to go away without so much trouble.
> > >
> > > You mean sfence? lfence in rmb is definitely needed.
> >
> > I mean lfence in smp_rmb().
>
> One point of rmb is to stop speculative loads and I don't think we
> can get that without lfence.

smp_rmb() should not need to do anything because loads are done
in order anyway. Both AMD and Intel have committed to this now.

The important point is that they *appear* to be done in order. AFAIK,
the CPUs can still do speculative and out of order loads, but throw
out the results if they could be wrong.
