Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZBEDl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZBEDl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZBEDlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:41:14 -0500
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:43876 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752096AbZBEDlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:41:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ENmudXF0ADRkrok1mqLU/az8YbaiwgrwMhpZJ6kOfsSRrQKTr4T1IL+45um/ayQG/KwkEQU+sj+NMTEmPl5dSJEPs7M3r1n3Oe7VSLQsfMxZNpbkdBs1xg4r8DToGGKMfm8YXvKMT9thr041aeY8B6ai4vdNBX5mP0G3vea47qw=  ;
X-YMail-OSG: VV0l6tEVM1njWs7h0I32cETseR77ZThzp06iRvoRG1p_mw65XjwmifMKmDS663eZDCvnbwq8JeQLDXA.KmMKLnCLvJ8yNIfCAS7dw7C1La1AyV1Yw3F20.PVe1ts0SdMyzPKrLf3NNwrBOBITojcCiGvpZDDMLska8Hua8_uJjCUVfrH6XM2N.4wwYrtXQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Date: Thu, 5 Feb 2009 14:40:41 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
References: <20090130012315.GB19554@duck.suse.cz> <200902031311.02378.nickpiggin@yahoo.com.au> <1233677565.7246.15.camel@think.oraclecorp.com>
In-Reply-To: <1233677565.7246.15.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051440.42176.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 03:12:45 Chris Mason wrote:
> On Tue, 2009-02-03 at 13:11 +1100, Nick Piggin wrote:

> > The interesting thing is why is this causing such a slowdown. If there is
> > only a single main file active in the workload, then I don't see why this
> > patch should make such a big difference. In either case, wouldn't pdflush
> > come back and just start writing out from the start of the file anyway?
>
> Perhaps the difference is that without the patch, pdflush will return
> after running congestion_wait()?  This would give bdb and iozone a
> chance to fill in more pages, and increases the chances we'll do
> sequential IO.

That's a possible explanation. I'll do some iozone runs and see if I can
work out what's going on. If we can distill the "goodness" of the previous
offset-wrap behaviour without reverting to make writeout more offset
dependent, that would be nice -- it might even benefit other cases that
weren't previously hitting the offset wrap case.

Worst case, if we can't come up with something simple and obvious for 2.6.29,
we can restore the old behaviour until we can come up with something better.

Thanks,
Nick

