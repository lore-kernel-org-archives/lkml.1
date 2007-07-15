Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbXGOX7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbXGOX7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbXGOX7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:59:06 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:49239 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755648AbXGOX7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:59:04 -0400
X-Nifty-SrcIP: [210.170.245.86]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=lQa5M7NehFSWUF/j6d6Qe07B0J3WCNljjH3bHXceD8SxJ1eQFAckLTrWYsk/n22Iu32s7tSLqWSOJeMtEn8gVg==  ;
From: TAKADA Yoshihito <takada@mbf.nifty.com>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707152106.28437.juergen127@kreuzholzen.de>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707152106.28437.juergen127@kreuzholzen.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.064
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.28.01 [ja]
Message-ID: <20070715235900.24658.qmail@smb518.nifty.com>
Date: Mon, 16 Jul 2007 08:59:00 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
Thanks. you are right. TSC is still unstable.

On Sun, 15 Jul 2007 21:06:27 +0200
Juergen Beisert <juergen127@kreuzholzen.de> wrote:

> Hi,
> 
> On Sunday 15 July 2007 14:00, TAKADA Yoshihito wrote:
> > Hi. I reported to remove pit_latch_buggy(http://lkml.org/lkml/2007/2/10/8).
> > In the report, I stated that TSC was unstable.
> > When I installed 2.6.21, GeodeGX's TSC is stable.
> 
> GeodeGX1's TSC is stable until you activate halt/suspend feature. In 
> arch/i386/kernel/cpu/cyrix.c:geode_configure() it will be activated by 
> default. But due to a macro failure the line
>   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> does nothing.
> Replace the setCx86/getCx86 macros by the attached patch, and the TSC will be 
> unstable again!
> 
> So it makes sense to mark the TSC unstable if the halt/suspend feature is 
> activated.
> 
> Juergen

-- 
TAKADA <takada@mbf.nifty.com>

