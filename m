Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZCLMpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZCLMpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZCLMpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:45:19 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:23037 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754947AbZCLMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:45:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SNcLnReBsk/V9m6OtaAUV9ebsRUfsSUyJraD3NlJp1aROqcp+4CRpIkUkpdy3OU2hgHAJVJ7/vMkzhq71gl1esNHit+87+EhZwlqlZxb3Gf9OpqCnwPxRcdxB/JLn9mcVSnnZVLBTQa0u9A4hCnWNuYTVxQZDxgkii7bPtnUixg=  ;
X-YMail-OSG: upYS2wgVM1lbZ_.zeeQWvRCkVeplqxWki1_y4MCU5jTf5vS5bGywSUi4Jk5VgHAZybFeb40kJsuAw7Xxk1NjqE_82Qr6IQrEXGUa.Ak6CFmvsboUVaJ9Sj8E2a5uYmzVgEHXCZsPfd.02hi99zLA9D05fXhPO1VwZ3As0qBaRlYvTD2n8LXDPAaqYZ_wTA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 23:45:13 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120524.34150.phillips@phunq.net> <20090312123230.GA14425@parisc-linux.org>
In-Reply-To: <20090312123230.GA14425@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122345.13787.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 23:32:30 Matthew Wilcox wrote:
> On Thu, Mar 12, 2009 at 05:24:33AM -0700, Daniel Phillips wrote:
> > On Thursday 12 March 2009, Nick Piggin wrote:
> > > That's interesting. Do you handle 1K block sizes with 64K page size? :)
> >
> > Not in its current incarnation.  That would require 32 bytes worth of
> > state while the current code just has a 4 byte map (4 bits X 8 blocks).
> > I suppose a reasonable way to extend it would be 4 x 8 byte maps.  Has
> > somebody spotted a 64K page?
>
> I believe SGI ship their ia64 kernels configured this way.  Certainly
> 16k ia64 kernels are common, which would (if I understand your scheme
> correctly) be 8 bytes worth of state in your scheme.

I think some distros will (or do) ship configs with 64K page size for
ia64 and powerpc too. I think I have heard of people using 64K pages
with ARM. There was some (public) talk of x86-64 getting a 16K or 64K
page size too (and even if not HW, some people want to be able to go
bigger SW pagecache size).

I wouldn't expect 64K page and 1K block to be worth optimising for
(although 64K page systems could easily use older or shared 4K block
filesystems). But just keep in mind that a good solution should not
rely on PAGE_CACHE_SIZE for correctness.

