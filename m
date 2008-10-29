Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYJ2OxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYJ2OxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYJ2Oww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:52:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbYJ2Oww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:52:52 -0400
Message-ID: <49087871.3010303@redhat.com>
Date: Wed, 29 Oct 2008 10:51:29 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Fix a race condition accessing oops_in_progress.  Which may be changed on
> multiple CPU simultaneously, but it is changed via non-atomic operation
> ++/--.  This patch changes the definition of oops_in_process from int to
> atomic_t, and accessing method to atomic operations.

You also need barriers.  I believe rmb() before atomic_read() and wmb() after 
atomic_set() should suffice.

-- Chris
