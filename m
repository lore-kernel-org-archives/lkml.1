Return-Path: <linux-kernel-owner+w=401wt.eu-S934562AbZHEOpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562AbZHEOpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbZHEOpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:45:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45611 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934256AbZHEOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:45:08 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
From: Andi Kleen <andi@firstfloor.org>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<20090805112133.6552.69619.sendpatchset@localhost.localdomain>
Date: Wed, 05 Aug 2009 16:45:08 +0200
In-Reply-To: <20090805112133.6552.69619.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Wed, 5 Aug 2009 07:19:12 -0400")
Message-ID: <87zlaeiakr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Introduce a new config option KEXEC_AUTO_RESERVE for x86.

The description of the feature belongs in the changelog.

I like the basic idea, but:

> +config KEXEC_AUTO_RESERVE
> +	bool "automatically reserve memory for kexec kernel"
> +	depends on KEXEC
> +	default y
> +	---help---
> +	  Automatically reserve memory for a kexec kernel, so that you don't
> +	  need to specify numbers for the "crashkernel=X@Y" boot option,
> +	  instead you can use "crashkernel=auto".
> +	  On x86, 128M is reserved.

The obvious problem is the hardcoded 128MB (and 128MB is very large
for a crash kernel anyways)

More useful would seem a crashkernel=size@auto

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
