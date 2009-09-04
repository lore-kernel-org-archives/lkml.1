Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZIDDsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZIDDsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 23:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932568AbZIDDsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 23:48:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbZIDDsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 23:48:10 -0400
Message-ID: <4AA08DD3.5010509@kernel.org>
Date: Fri, 04 Sep 2009 12:47:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <4AA080A0.7010804@kernel.org> <4AA08283.5020306@kernel.org> <4AA08B09.50503@zytor.com>
In-Reply-To: <4AA08B09.50503@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 03:47:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 09/03/2009 07:59 PM, Tejun Heo wrote:
>> Another question.  Other than saving and loading an extra segment
>> register on kernel entry/exit, whether using the same or different
>> segment registers doesn't look like would make difference
>> performance-wise.  If I'm interpreting the wording in the optimization
>> manual correctly, it means that each non-zero segment based memory
>> access will be costly regardless of which specific segment register is
>> in use and there's no way we can merge segment based dereferences for
>> stackprotector and percpu variables.
>>
> 
> It's correct that it doesn't make any difference for access, only for load.

Heh... here's a naive and hopeful plan.  How about we beg gcc
developers to allow different segment register and offset in newer gcc
versions and then use the same one when building with the new gcc?
This should solve the i386 problem too.  It would be the best as we
get to keep the separate segment register from the userland.  Too
hopeful?

Thanks.

-- 
tejun
