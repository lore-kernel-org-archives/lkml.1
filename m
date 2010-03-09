Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0CILnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:43:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:38783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0CILn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:43:28 -0500
Message-ID: <4B963441.40000@kernel.org>
Date: Tue, 09 Mar 2010 20:42:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu,lockdep: implement and use is_static_percpu_address()
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org> <1268133942.4162.2.camel@twins>
In-Reply-To: <1268133942.4162.2.camel@twins>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 11:43:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 03/09/2010 08:25 PM, Peter Zijlstra wrote:
>> +/* can't distinguish from other static vars, always false */
>> +static inline bool is_static_percpu_address(unsigned long addr)
>> +{
>> +	return false;
>> +}
> 
> At this point it might make sense to simply fail to compile if lockdep
> is enabled as well.
> 
> I'm not sure if there's many SMP archs that don't have this and do have
> lockdep, but simply failing this test isn't really an option.

That might be better.  Returning %false isn't that bad tho.  There
really is no distinction between percpu and !percpu variable on UP and
static variable address match will catch both.

>>  /**
>> + * is_static_percpu_address - test whether address is from static percpu area
>> + * @addr: address to test
>> + *
>> + * Test whether @addr belongs to static percpu area.  Module static
>> + * percpu areas allocated via __alloc_reserved_percpu() is not
>> + * considered.  Use is_module_address() for those.
>> + *
>> + * RETURNS:
>> + * %true if @addr is from static percpu area, %false otherwise.
>> + */
> 
> So is_module_address() will only return true for static per-cpu module
> storage, right?

Right, got confused there.  I'll update is_static_percpu_address() to
test for reserved regions too.

Thanks for the review.

-- 
tejun
