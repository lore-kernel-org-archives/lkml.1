Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbZDDF4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbZDDF4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 01:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZDDFzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 01:55:53 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:46832 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751621AbZDDFzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 01:55:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=SattMTwrjHIcc6I0cBSLD/wqjBtvMRQfJHaEooQxeUTN5u8NLf6kytvnqA2lnMj1BNfSCnxyuJrxLr97hF4qZv0up14FZxK6lQUYrpJGj5JAYN79j9pNZoRp8lKHlEYpyk44woNCTO74Jc1CJKRyGSt2M1xmhJbW6aHkCSFXTCc=  ;
X-YMail-OSG: Khgcih0VM1kWHTYdtr_oCLFz3NmKt2n4zcwBTiEafLTz1bhdsUAQeYnMM0wDF1AEwq1imt5cmL90nz.aIqy175nLx7uJW.iycGK5xqsE.SVIa9RmQI5cfyxSMZHdT9RTv2XlUUSNbUXo0fB7LeTVarxcBLWwUTi7D5CJGJd561MaxyLDWcs7LzDK2TQUoM5rZTnsr9N4gnm9pW59sRywnHGLDgc3AFSB2_ps77CX8JjkMSvVQfI_DgrfBLob4Ep8p3neVeOzM1swvXQn.LMa4icjlOzihLhGS5f3nKa9xy6ZNlVw3jZy
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.29
Date: Fri, 3 Apr 2009 16:05:20 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090325183011.GN32307@mit.edu> <49D56DF6.5020300@garzik.org> <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904031605.20832.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 13:16:08 Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, Jeff Garzik wrote:
> > 
> > The most interesting thing I found:  the SSD does 80 MB/s for the first ~1 GB
> > or so, then slows down dramatically.  After ~2GB, it is down to 32 MB/s.
> > After ~4GB, it reaches a steady speed around 23 MB/s.
> 
> Are you sure that isn't an effect of double and triple indirect blocks 
> etc? The metadata updates get more complex for the deeper indirect blocks.
> 
> Or just our page cache lookup? Maybe our radix tree thing hits something 
> stupid. Although it sure shouldn't be _that_ noticeable.

Hmm, I don't know what you have in mind. page cache lookup should be
several orders of magnitude faster than a disk can write the pages out?

Dirty/writeout/clean cycle still has to lock the radix tree to change
tags, but that's really not going to be significantly contended (nor
does it synchronise with simple lookups).
