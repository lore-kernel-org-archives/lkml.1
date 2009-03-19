Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZCSQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZCSQG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZCSQGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:06:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:47823 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZCSQGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R5UcHQh349GFacRP1vzUdbi9yFwwtcNFZDam/BqcBk3lQTRHhvUhd2BUQijkfnCRhq
         Qu3Uizd77bwiGq4iKW4CFekGRtnRHmXw7zTvGFKBOw2pCN6cnuVcHtcWRpdbrSerT6q1
         bMKxqxfthe00OxmyFCAjVtO5IXmrVIXAaMZEE=
Message-ID: <49C26D91.3010904@gmail.com>
Date: Thu, 19 Mar 2009 17:06:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-4.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: robert.moore@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
References: <49BCDCAA.8040309@gmail.com>	 <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com> <1237174943.4193.37.camel@minggr.sh.intel.com> <49BE7EE6.3070107@gmail.com> <49C0AC13.7040107@gmail.com>
In-Reply-To: <49C0AC13.7040107@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.3.2009 09:08, Jiri Slaby wrote:
> On 16.3.2009 17:31, Jiri Slaby wrote:
>> On 16.3.2009 04:42, Lin Ming wrote:
>>>> sometimes, when booting up/resuming from disk, I get an oops[1].
>>>>
>>>> obj_desc->common_field.access_bit_width is zero, but even after the
>>>> loop. Division before the loop is apparently OK.
>>>
>>> Would please try below debug patch to see which region filed is
>>> accessed?
>
> I'm confused, but keep trying.

Got it again. obj_desc->common_field.node is martian too (0x4000000), so 
the added acpi_get_name dies:
http://www.fi.muni.cz/~xslaby/sklad/panics/acpi_oops1.png

Whole common_field seems to be mangled. Ideas?
