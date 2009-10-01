Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZJAVvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZJAVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZJAVvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:51:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:53265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZJAVvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:51:08 -0400
Date: Thu, 1 Oct 2009 09:22:20 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Julian Anastasov <ja@ssi.bg>
Cc: Hannes Eder <heder@google.com>, Wensong Zhang <wensong@linux-vs.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] ipvs: Add boundary check on ioctl arguments
Message-ID: <20091001092220.2ea81cb2@infradead.org>
In-Reply-To: <Pine.LNX.4.58.0909302231360.2853@u.domain.uli>
References: <20090930131109.2b3f71b8@infradead.org>
	<4AC35F44.60707@google.com>
	<20090930171833.5ce0011d@infradead.org>
	<Pine.LNX.4.58.0909302231360.2853@u.domain.uli>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 22:41:05 +0300 (EEST)
Julian Anastasov <ja@ssi.bg> wrote:

> 
> 	Hello,
> 
> On Wed, 30 Sep 2009, Arjan van de Ven wrote:
> 
> > fair enough; updated patch below



> Later len can be checked
> additionally and surely can exceed 128 (include/linux/ip_vs.h has
> all user structures). 

the on-stack structure currently is 128 bytes though...

> Can you show the exact cmd and len
> used, may be there is error in some command or may be the
> provided user structure is wrong?

this comes from code inspection using gcc features; this
is one of the (few) cases in the kernel where gcc cannot prove
that the copy_from_user() length for the copy-to-stack is sufficiently
bounds checked. I'm trying to make sure all these cases have
complete enough checks, both for the obvious security reasons but
also to be able to then make gcc emit a warning to prevent future
issues from popping up.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
