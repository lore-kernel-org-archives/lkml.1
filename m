Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZBJVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZBJVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZBJVxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:53:47 -0500
Received: from p02c12o143.mxlogic.net ([208.65.145.76]:53468 "EHLO
	p02c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbZBJVxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:53:46 -0500
Message-ID: <4991F75D.7010100@steeleye.com>
Date: Tue, 10 Feb 2009 16:53:33 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, jnelson-kernel-bugzilla@jamponi.net,
       Pavel Machek <pavel@ucw.cz>, stable@kernel.org
Subject: Re: [PATCH 1/1] NBD: fix I/O hang on disconnected nbds
References: <4990743F.1070409@steeleye.com> <20090210133537.23b1779a.akpm@linux-foundation.org>
In-Reply-To: <20090210133537.23b1779a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2009 21:53:33.0983 (UTC) FILETIME=[04F8AAF0:01C98BCA]
X-Spam: [F=0.2000000000; S=0.200(2009020301)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 09 Feb 2009 13:21:51 -0500
> Paul Clements <paul.clements@steeleye.com> wrote:

>> This problem was introduced by the new request handling thread code
>> ("NBD: allow nbd to be used locally", 3/2008), which entered into 
>> mainline around 2.6.25.
> 
> Seems that the patch applies to 2.6.26, but not to 2.6.25.

OK, couldn't remember the exact timeframe.

>> The fix, which is fairly simple, is to restore the check for lo->sock
>> being NULL in do_nbd_request. This causes I/O to an uninitialized nbd to
>> immediately fail with an I/O error, as it did prior to the introduction 
>> of this bug.
> 
> I marked this as needing backporting into 2.6.26.x, 2.6.27.x and
> 2.6.28.x.  OK?

Yes, that would be a good idea.

Thanks,
Paul


