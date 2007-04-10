Return-Path: <linux-kernel-owner+w=401wt.eu-S1031302AbXDJRrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031302AbXDJRrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031304AbXDJRrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:47:23 -0400
Received: from gw.goop.org ([64.81.55.164]:52220 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031302AbXDJRrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:47:23 -0400
Message-ID: <461BCDA9.2060206@goop.org>
Date: Tue, 10 Apr 2007 10:47:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add spaces on either side of case "..." operator.
References: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6> <20070410090555.d847d466.akpm@linux-foundation.org>
In-Reply-To: <20070410090555.d847d466.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> #define AUDIT_FIRST_USER_MSG    1100    /* Userspace messages mostly uninteresting to kernel */
> #define AUDIT_USER_AVC          1107    /* We filter this differently */
> #define AUDIT_LAST_USER_MSG     1199
>
> and CPP turns that into
>
>  case 1100 ...1199:
>  case 2100 ...2999:
>
> and it does the same when the comments are stripped from the #defines.
>
> So we were saved by the trailing space which cpp added to the expanded
> macro.  I wonder why cpp did that, and to what extent one can rely cpp
> doing that.

I think its required to.  If it didn't, it would be effectively pasting
two tokens together without the ## operator.  But putting spaces in is
safer - or putting () around the numbers.

    J
