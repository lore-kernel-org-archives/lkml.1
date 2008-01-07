Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYAGUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYAGUpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbYAGUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:45:05 -0500
Received: from ns.suse.de ([195.135.220.2]:33471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbYAGUpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:45:04 -0500
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, bcrl@kvack.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
From: Andi Kleen <andi@firstfloor.org>
References: <20080106220307.GU28570@kvack.org>
	<m1ir26ktqi.fsf@ebiederm.dsl.xmission.com>
	<20080106.231040.222338659.davem@davemloft.net>
Date: Mon, 07 Jan 2008 21:45:02 +0100
In-Reply-To: <20080106.231040.222338659.davem@davemloft.net> (David Miller's message of "Sun\, 06 Jan 2008 23\:10\:40 -0800 \(PST\)")
Message-ID: <p73wsqlqsa9.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
>> So is this a bug report telling me that there are users with
>> 10k or 100k interfaces that care.  So we need to fix sysctl.
>
> Unquestionably, we do, it's a major regression.
>
> People create thousands of VLAN devices, as one of many examples, all
> the time.

It might be an reasonable option to just stop creating sysctl entries
for interfaces after some threshold. I presume people who have that
many interfaces will mostly work through {default,all}/* anyways.

I think that would be a better option than to complicate sysctl.c
for this uncommon case.

-Andi
