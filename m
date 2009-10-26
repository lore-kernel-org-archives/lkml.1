Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZJZKMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZJZKMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 06:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZJZKM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 06:12:29 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44587 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZJZKM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 06:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SptILV6A3Thi3F0az//oC7nSjOsCpI7zGQ9cOcPVYurJ6GINiZCPZvkNuM6ocj9mrZ
         AOoH4FCojtjDF7JX7H7+xc19KzZ0nXByGnEUda/FvXLxLVslNDDZa3uAmkgLI5rEizfK
         2BqTbjQjOuInAo0c9I8hHSbSsnNbKMb/Wowp8=
Message-ID: <4AE5760E.5080401@gmail.com>
Date: Mon, 26 Oct 2009 11:12:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/1] crash_dump: fix non-pae kdump kernel memory accesses
References: <1256312729-22935-1-git-send-email-jirislaby@gmail.com> <20091025162018.GB20391@elte.hu>
In-Reply-To: <20091025162018.GB20391@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2009 05:20 PM, Ingo Molnar wrote:
>> +#ifndef CONFIG_X86_PAE
>> +/* non-PAE kdump kernel executed from a PAE one will crop high pte bits and
>> +   poke unwanted space counting again from address 0, we don't want that */
>> +static inline bool is_crashed_pfn_valid(unsigned long pfn)
>> +{
>> +	/* on non-PAE pte must fit into unsigned long
>> +	   in fact the test is (pfn & 0x000fffff) */
>> +	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
>> +}
>> +#else
>> +static inline bool is_crashed_pfn_valid(unsigned long pfn) { return true; }
>> +#endif
> 
> i'd suggest to push the #ifdef inside the function.

I posted a v2 patch a second ago. Thanks.
