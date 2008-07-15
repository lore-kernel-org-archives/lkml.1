Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYGOGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYGOGSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYGOGSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:18:09 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:45549 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754541AbYGOGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:18:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cR7hKAyJBOKP4aCU/v9XsPFfCuRbAvPPvaVeNH58Sz/qp0txAjlWZt1oLP1AR7LZTHEdq9zGX/Kt7r3tiAShFJFcU1GyHBjWEi/mIQj7sGfQ2bW3zM6X64LeoxGk39P+E68a+qH3i2VEHsWNqCJGKYfGP4VUmXnaY58pjOLMSDc=  ;
X-YMail-OSG: JB8r9TMVM1kg.gOesuOEvf3fd9i2TYiFqDmv9CsyN5F21C4e0Vj9CGvT4cBNoqgw5M54iU5iRcV7PPtLwcNao2x2K4.yUM43co4Rb5GczlqKDa3HzOA5ZajtGbYo4cLXt7M-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs bug in 2.6.26-rc9
Date: Tue, 15 Jul 2008 16:17:58 +1000
User-Agent: KMail/1.9.5
Cc: Lachlan McIlroy <lachlan@sgi.com>, Mikael Abrahamsson <swmike@swm.pp.se>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <487B019B.9090401@sgi.com> <20080714121332.GX29319@disturbed>
In-Reply-To: <20080714121332.GX29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151617.58329.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 22:13, Dave Chinner wrote:

> Christoph and I were contemplating this problem with ->page_mkwrite
> reecently. The problem is that we can't, right now, return an
> EAGAIN-like error to ->page_mkwrite() and have it retry the
> page fault. Other parts of the page faulting code can do this,
> so it seems like a solvable problem.
>
> The basic concept is that if we can return a EAGAIN result we can
> try-lock the inode and hold the locks necessary to avoid this race
> or prevent the page fault from dirtying the page until the
> filesystem is unfrozen.
>
> Added linux-mm to the cc list for discussion.

It would be easily possible to do, yes.
