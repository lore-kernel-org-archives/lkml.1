Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZKLKRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZKLKRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZKLKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:17:34 -0500
Received: from lo.gmane.org ([80.91.229.12]:55108 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZKLKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:17:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH 1/4] drivers/net/enic: decrement sizeof size in strncmp
Date: Thu, 12 Nov 2009 11:17:24 +0100
Message-ID: <4AFBE0B4.6070904@web.de>
References: <Pine.LNX.4.64.0911120848100.16627@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 129.26.101.112
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
In-Reply-To: <Pine.LNX.4.64.0911120848100.16627@ask.diku.dk>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Law all <julia@diku.dk>
> 
> As observed by Joe Perches, sizeof of a constant string includes the
> trailing 0.  If what is wanted is to check the initial characters of
> another string, this trailing 0 should not be taken into account.  If an
> exact match is wanted, strcmp should be used instead.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression foo;
> constant char *abc;
> @@
> 
> strncmp(foo, abc, 
> - sizeof(abc)
> + sizeof(abc)-1
>  )
> // </smpl>
> 
<snip>
How about this pattern (uses length of first argument):

strncmp(foo, abc,
- sizeof(foo)

?
-- 
Best regards,
Jörg-Volker.

