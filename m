Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZJRW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZJRW2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZJRW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:28:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:41685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbZJRW2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:28:37 -0400
Message-ID: <4ADB967A.4080707@suse.com>
Date: Sun, 18 Oct 2009 18:28:10 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter -

Commit 34d76c41 introduced the update_shares_data percpu, but it ends up
causing problems on large ia64 machines. Specifically, ia64 is limited
to 64k in percpu vars and with NR_CPUS=4096, that ends up being 32k by
itself. It ends up causing link errors since that is how ia64 enforces
the 64k limit.

I can take a deeper look at finding a workable solution but thought I'd
mention it in case you had ideas already.

-Jeff

-- 
Jeff Mahoney
SuSE Labs
