Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbXFZA4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbXFZA4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXFZAz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:55:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52803 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXFZAz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:55:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com>
	<20070625233433.GA32306@one.firstfloor.org>
	<200706251636.53636.jesse.barnes@intel.com>
Date: Mon, 25 Jun 2007 18:54:49 -0600
In-Reply-To: <200706251636.53636.jesse.barnes@intel.com> (Jesse Barnes's
	message of "Mon, 25 Jun 2007 16:36:52 -0700")
Message-ID: <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> writes:

> On Monday, June 25, 2007 4:34:33 Andi Kleen wrote:
>> > This patch fixes a bug in the last patch that caused the code to
>> > run on non-Intel machines (AMD machines apparently don't need it
>>
>> Actually the problem can happen on AMD too, but the symptoms can
>> be different and there can be more wrong than just the MTRRs.
>
> I should have been more specific in the changelog.  My understanding is 
> that AMD systems don't need it for memory above 4G, and since the code 
> doesn't handle holes (no test systems, nor any real reports that I've 
> seen), it's not that useful for finding problems below 4G.  We can 
> always change that later if needed though.

For the K7 and K8 cores AMD systems are exactly like Intel systems
with respect to MTRRs (although AMD systems also have additional registers)
For the K9 core (i.e. AMD socket F or the K8 with DDR2 support) there
is an additional mechanism that makes everything above 4G write-back
cacheable without using any MTRRs.

So only on the very latest AMD cpus would this code not be applicable.

Eric
