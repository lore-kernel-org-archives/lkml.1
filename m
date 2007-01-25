Return-Path: <linux-kernel-owner+w=401wt.eu-S965755AbXAYK0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbXAYK0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 05:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965758AbXAYK0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 05:26:39 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34628 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965755AbXAYK0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 05:26:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VNh/3AsBVfNWk7QyYg27s1mfmOyBgaAXMxco5kLv+Lo7oUk5NGFtMP+Wh3QzvaL2WjiWP0Zb5XTcZuCnIdj7epc9a0+LkLJEn7AiwZWytUzsctoIkgW3Hriw3uZLyCjOrTU2wxbSL9R5txZ6a/NGbI+HHgTB6S529Wton/2t2FA=  ;
X-YMail-OSG: ZSiPeooVM1n7QF.FfGSV.EgHDabCwPNbjJOodvf87.4sKdZ.iZjWuuhugALKPqPyhtWv96p9VA--
Message-ID: <45B885CE.4030206@yahoo.com.au>
Date: Thu, 25 Jan 2007 21:26:22 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com> <45B7FE1C.3070807@yahoo.com.au> <20070125015204.GV33919298@melbourne.sgi.com> <45B80F65.6010206@yahoo.com.au> <20070125034227.GX33919298@melbourne.sgi.com> <45B83139.1040007@yahoo.com.au> <20070125074018.GB33919298@melbourne.sgi.com>
In-Reply-To: <20070125074018.GB33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:

> Only if we leave the page in the page cache. If we toss the page,
> the time it takes to do the I/O for the page fault is enough for
> the direct I/o to complete. Sure it's not an absolute guarantee,
> but if you want an absolute guarantee:

So I guess you *could* relax it in theory... Anyway, don't take
my pestering as advocacy for wanting XFS to do something more
clever in such a corner case. I think you're quite right to be
conservative and share codepaths between direct IO read and
write.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
