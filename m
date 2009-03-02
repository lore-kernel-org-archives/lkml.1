Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZCBUrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZCBUrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCBUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:47:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZCBUrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:47:36 -0500
Message-ID: <49AC459F.10606@kernel.org>
Date: Mon, 02 Mar 2009 12:46:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Kevin O'Connor" <kevin@koconnor.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org
Subject: Re: [PATCH] x86: ioremap mptable -v2
References: <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain> <49A9FC9A.2030707@kernel.org> <20090301180420.GA27040@morn.localdomain> <49AB511E.9010507@kernel.org> <20090302101823.GJ20897@elte.hu> <49AC3C8C.8070702@kernel.org> <20090302202918.GA14471@elte.hu>
In-Reply-To: <20090302202918.GA14471@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> V3: according to Ingo, seperate get_mpc_size()
> 
> No, that was not my suggestion. My suggestion was to separate 
> this whole 'else if' branch:
> 
>>  	} else if (mpf->physptr) {
>> +		struct mpc_table *mpc;
>> +		unsigned long size;
>>  
>> +		size = get_mpc_size(mpf->physptr);
>> +		mpc = early_ioremap(mpf->physptr, size);
>>  		/*
>>  		 * Read the physical hardware table.  Anything here will
>>  		 * override the defaults.
>>  		 */
>> -		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
>> +		if (!smp_read_mpc(mpc, early)) {
>>  #ifdef CONFIG_X86_LOCAL_APIC
>>  			smp_found_config = 0;
>>  #endif
> 
> ... into a helper function - if that improves the code.
oh, i missed it
> Your patch does early_ioremap, iounmap then ioremap and iounmap - 
> quite pointlessly.
try to get exact mpc size.
> 
> You should resist cleanup suggestions that make the code worse, 
> even if it comes from a maintainer :-)

we could do that later. to make __get_smp_config smaller and readable.

YH
