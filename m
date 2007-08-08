Return-Path: <linux-kernel-owner+w=401wt.eu-S937238AbXHHRS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937238AbXHHRS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763318AbXHHRSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:18:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54172 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763792AbXHHRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:18:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
References: <1185851583.23149.30.camel@caritas-dev.intel.com>
	<200708081208.01080.ak@suse.de>
	<m1tzrac8hz.fsf@ebiederm.dsl.xmission.com>
	<200708081822.07758.ak@suse.de>
Date: Wed, 08 Aug 2007 11:17:18 -0600
In-Reply-To: <200708081822.07758.ak@suse.de> (Andi Kleen's message of "Wed, 8
	Aug 2007 18:22:07 +0200")
Message-ID: <m1wsw6aqu9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> 
>> This is the classic skip the 16bit code and enter the kernel
>> in 32bit mode filling in the fields that the 16bit mode code would
>> have filled in the same way approach.
>
> kexec can use it because it's in tree.

Not the part that actually uses it.

> But I don't think using it by out of tree stuff is a good idea.
>
> e.g. assuming we need a new field. How would we extend this?
> There is no version number or anything to detect this.
>
> For in tree code it can be just updated. But weirdo-EFI-boot loader
> cannot.

So far the logic has been.

Inspect bzImage.  And get boot protocol version.
If field we need for returning data is not supported do not give
data.  Or something like that.  Usually the fields always exist
and you can just fill them in and we only append to the boot
protocol structure.

In practice this has been working for the last 7 years or so,
for EFI, and LinuxBIOS, and kexec, and Gujin and I don't remember what
else.

It isn't the prettiest thing in the world but it works and everybody
who needs it uses it.  Which tend to be the important parts for a
standard.

Eric
