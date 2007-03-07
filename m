Return-Path: <linux-kernel-owner+w=401wt.eu-S965486AbXCGTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486AbXCGTK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965502AbXCGTK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:10:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51581 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965486AbXCGTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:10:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arjan van de Ven <arjan@infradead.org>
Cc: vgoyal@in.ibm.com,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, akpm@linux-foundation.org,
       ak@suse.de, hpa@zytor.com, magnus.damm@gmail.com, lwang@redhat.com,
       dzickus@redhat.com, pavel@suse.cz, rjw@sisk.pl
Subject: Re: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
References: <20070307065703.GA23412@in.ibm.com>
	<1173280059.3540.5.camel@laptopd505.fenrus.org>
Date: Wed, 07 Mar 2007 12:08:28 -0700
In-Reply-To: <1173280059.3540.5.camel@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Wed, 07 Mar 2007 07:07:39 -0800")
Message-ID: <m1abyodg7n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Wed, 2007-03-07 at 12:27 +0530, Vivek Goyal wrote:
>> Hi,
>> 
>> Here is another attempt on x86_64 relocatable bzImage patches(V4). This
>> patchset makes a bzImage relocatable and same kernel binary can be loaded
>> and run from different physical addresses.
>
>
> have these patches been extensively tested with various suspend
> scenarios? (S1,S3,S4 in acpi speak or s2ram and s2disk in Linux speak)

It should be noted what broke was the non-portable constructs in the generic
suspend code.

In particular using __pa() outside of architecture code is not allowed.
Using virt_to_phys() on addresses not part of the kernel's linear mapping is
not generically supported.

text/data are not required to be part of the kernel's linear mapping.

This patchset now causes all code using these non-portable constructs to
fail on x86_64.  Which I think is a good thing so we can more easily
spot these kinds of problems.

Patches 15 and 16 appear to make the swpsuspend code rely on portable
constructs.   I will let Vivek reply to the amount of testing he has
done in this area.

Eric
