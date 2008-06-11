Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYFKLmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYFKLmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYFKLmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:42:39 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31228 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbYFKLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:42:39 -0400
Message-ID: <484FBA05.4010103@panasas.com>
Date: Wed, 11 Jun 2008 14:41:57 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
References: <20080610160408.GB11685@cs181133002.pp.htv.fi> <20080610162450.GB13538@kroah.com> <20080610181206.GF11685@cs181133002.pp.htv.fi> <20080610212859.GB26249@kroah.com> <20080611082320.GM11685@cs181133002.pp.htv.fi> <484F98C5.3040202@panasas.com> <20080611095921.GN11685@cs181133002.pp.htv.fi>
In-Reply-To: <20080611095921.GN11685@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 11:42:02.0727 (UTC) FILETIME=[2A7C4F70:01C8CBB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Jun 11, 2008 at 12:20:05PM +0300, Boaz Harrosh wrote:
>> Adrian Bunk wrote:
>>> [1] and before anyone restarts the "kconfig is broken - select should 
>>>     follow dependencies" FUD: I've seen much talk and zero code for
>>>     this, and in my opinion the problem is much more difficult than
>>>     it appears at first sight
>> I had this crazy idea, Perhaps it would be easier to reverse the problem.
>> Introduce a kind of Lazy_Enable mode. Which means config is enabled but
>> gets it's use_count bumped up every time someone is dependent on it.
>> At the end, for optimization, any Lazy_Enable with zero count, is dropped.
>> Is that at all possible in current infrastructure?
>> (I admit I never looked at the source)
> 
> Wouldn't your "Lazy_Enable" do the same as "select" already does?
> 

No, I mean, for example, ISCSI_TCP will just "depends" on SCSI_ISCSI_ATTRS but 
SCSI_ISCSI_ATTRS is Lazy_Enable. So a user can always choose ISCSI_TCP if he 
wants to. At the end if there are no users for SCSI_ISCSI_ATTRS it is dropped.

Lazy_Enable is for these modules that say: "I have no purpose of my own
but only serve other needs"

Theoretically it looks like a simpler problem. (Pull vs Push)

>> Boaz
> 
> cu
> Adrian
> 

Just my $0.017
Boaz
