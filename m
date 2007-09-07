Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbXIGHVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbXIGHVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 03:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXIGHV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 03:21:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:38027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964902AbXIGHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 03:21:27 -0400
From: Andi Kleen <ak@suse.de>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Subject: Re: [PATCH]: x86_64: Remove unnecessary cast in prefetch()
Date: Fri, 7 Sep 2007 08:18:03 +0100
User-Agent: KMail/1.9.1
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <87tzq7cwnt.fsf@depni.sinp.msu.ru>
In-Reply-To: <87tzq7cwnt.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709070818.03995.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2007 22:27, Serge Belyshev wrote:
> It is ok to call prefetch() function with NULL argument, as specifically
> commented in include/linux/prefetch.h.  But in standard C, it is invalid to
> dereference NULL pointer (see C99 standard 6.5.3.2 paragraph 4 and note
> #84). Newer gcc versions (4.3 and above) will use that to conclude that "x"
> argument is non-null and thus wreaking havok everywhere prefetch() was
> inlined. Fixed by removing cast and changing asm constraint.
>
> This can be fixed better by using gcc's __builtin_prefetch().

I changed it to just use that. Thanks.

It seems like gcc 3.1/3.2 already supported it and that's the earliest gcc
still supported so it can be used unconditionally.

-Andi
