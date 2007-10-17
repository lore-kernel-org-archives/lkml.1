Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXJQI0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXJQI0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXJQI0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:26:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:58186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbXJQI0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:26:00 -0400
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v5 0/3] i386/x86_64 boot: 32-bit boot protocol
References: <1192168345.17539.42.camel@caritas-dev.intel.com>
	<1192586376.17856.26.camel@caritas-dev.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Oct 2007 10:25:57 +0200
In-Reply-To: <1192586376.17856.26.camel@caritas-dev.intel.com>
Message-ID: <p73odeyxi3u.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> Do you think it is a good idea to check the collision between setup data
> and memory area used during kernel boot through bootmem allocator?

You can't solve this through bootmem because x86-64 allocates memory
in several places before bootmem (using functions in e820.c) Right now
this is quite hackish with hard coded areas to avoid conflicts.  But I
recently had a need to allocate more memory that early too and changed
the code to a generic early reservation interface. With that it would
be relatively easy to reserve.

-Andi
