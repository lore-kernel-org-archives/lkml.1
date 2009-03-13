Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZCMJdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZCMJdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZCMJc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:32:59 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:21913 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751748AbZCMJc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:32:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Zb3KFrjdPChU6SEIWhTYP7Woh40EsR6IIrARiHGDiPLEs/vvlofn1e8kE2P9jEjhe7EjTx9Kl4Ct5qlDi+QbO9rN1qWxpcNVi/sL7uOe6kD4kHWY2E1UugHonXKJ2uXEQA01JkpBN3IgMbHvVD8fiGWJ86EFTiC0g+aReBBMKjg=  ;
X-YMail-OSG: R67Zl14VM1no.NNlnCPwOHO.dioE3e3t9u9DjCmTlITDlFGOBTaRQ5Nn6rTH5sgxZSIRtN_8OTUTHr1RU8cZdogmI54yfN7pnh5Onr5VCtLQ4yu.Vn8d2Tz7q6Och2PdFz9sDXPMAmMpVgjzPZZ6nMiMEP7CO1QVGnd8IPoI2WfcRDM0jIXOO60_.Gtmog--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Fri, 13 Mar 2009 20:32:47 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903122203.31502.nickpiggin@yahoo.com.au> <20090312170653.GC17104@mit.edu>
In-Reply-To: <20090312170653.GC17104@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903132032.48517.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 04:06:53 Theodore Tso wrote:
> On Thu, Mar 12, 2009 at 10:03:31PM +1100, Nick Piggin wrote:
> > It is basically already proven. It is faster with ext2 and it works with
> > XFS delalloc, unwritten etc blocks (mostly -- except where I wasn't
> > really able to grok XFS enough to convert it). And works with minix
> > with larger block size than page size (except some places where core
> > pagecache code needs some hacking that I haven't got around to).
> >
> > Yes an ext3 conversion would probably reveal some tweaks or fixes to
> > fsblock. I might try doing ext3 next. I suspect most of the problems
> > would be fitting ext3 to much stricter checks and consistency required
> > by fsblock, rather than adding ext3-required features to fsblock.
> >
> > ext3 will be a tough one to convert because it is complex, very stable,
> > and widely used so there are lots of reasons not to make big changes to
> > it.
>
> One possibility would be to do this with ext4 instead, since there are
> fewer users, and it has more a "development" feel to it.  OTOH, there

Yes I think ext4 would be the best candidate for the next conversion.


> are poeple (including myself) who are using ext4 in production
> already, and I'd appreciate not having my source trees on my laptop
> getting toasted.  :-)

Definitely ;)


> Is it going to be possible to make the fsblock conversion being
> something which is handled via CONFIG_EXT4_FSBLOCK #ifdefs, or are the
> changes too invasive to really allow that?  (Also note BTW that ocfs2
> is also using jbd2, so we need to be careful we don't break ocfs2
> while we're doing the fsblock conversion.)

Hmm, it would be difficult. I think once I get a patch working, it
wouldn't be too hard to maintain out of tree though (there tends to
be just a smallish number of patterns used many times). I'd start
by doing that, and see how it looks from there.

