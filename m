Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYAYBUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYAYBUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYAYBUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:20:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYAYBUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:20:01 -0500
Message-ID: <4799393A.5090605@redhat.com>
Date: Thu, 24 Jan 2008 20:19:54 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
References: <200801242336.00340.a1426z@gawab.com>
In-Reply-To: <200801242336.00340.a1426z@gawab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Greetings!
> 
> data=ordered mode has proven reliable over the years, and it does this by 
> ordering filedata flushes before metadata flushes.  But this sometimes 
> causes contention in the order of a 10x slowdown for certain apps, either 
> due to the misuse of fsync or due to inherent behaviour like db's, as well 
> as inherent starvation issues exposed by the data=ordered mode.
> 
> data=writeback mode alleviates data=order mode slowdowns, but only works 
> per-mount and is too dangerous to run as a default mode.
> 
> This RFC proposes to introduce a tunable which allows to disable fsync and 
> changes ordered into writeback writeout on a per-process basis like this:
> 
>       echo 1 > /proc/`pidof process`/softsync
> 
> 
> Your comments are much welcome!

This is basically a kernel workaround for stupid app behavior.  It wouldn't be 
the first time we've provided such an option, but we shouldn't do it without a 
very good justification.  At the very least, we need a test case that 
demonstrates the problem and benchmark results that prove that this approach 
actually fixes it.  I suspect we can find a cleaner fix for the problem.

	-- Chris
