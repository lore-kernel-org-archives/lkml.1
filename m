Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYFQBBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYFQBBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 21:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYFQBBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 21:01:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYFQBBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 21:01:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:in-reply-to:message-id:
	references:mime-version:content-type;
	b=HS06SYvT7bpx6pVf7Bp4JyKf4vpmJ3UqqjpdcrTi5zmbkB5iqgSu1kWIfMYPlEaq6
	WR4ZqwKIkqjxf7q0rm1fQ==
Date: Mon, 16 Jun 2008 18:01:11 -0700 (PDT)
From: Divyesh Shah <dpshah@google.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Divyesh Shah <dpshah@google.com>, axboe@kernel.dk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>
Subject: Re: [BUGFIX][RESEND] Fix the starving writes bug in the anticipatory
 IO scheduler
In-Reply-To: <200806161318.57435.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0806161723590.15011@austin.corp.google.com>
References: <935894B7-5FD4-4C3D-9A74-6B18E532462B@google.com>
 <200806161318.57435.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Nick Piggin wrote:

> Well, thanks for the report and test case. I'm a bit out of the
> loop when it comes to IO scheduling these days, however the fix
> seems good to me.
>
> Does google still use AS scheduling? This doesn't introduce any
> performance regressions that you can tell?

Yes we use AS scheduler. Benchmarking results on workloads have shown that 
AS does as good a job (and better in some cases) as CFQ. When there is 
a single thread reading/writing to disk, AS performs as well as CFQ. With 
multiple threads doing IO such that there are a lot of outstanding 
requests, CFQ performs worse than AS in terms of throughput.

-Divyesh.
