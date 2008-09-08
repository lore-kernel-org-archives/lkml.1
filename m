Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbYIHADc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbYIHADc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYIHADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:03:25 -0400
Received: from gw.goop.org ([64.81.55.164]:53705 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYIHADY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:03:24 -0400
Message-ID: <48C46BCB.2060209@goop.org>
Date: Sun, 07 Sep 2008 17:03:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org>
In-Reply-To: <20080907234418.GB26079@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Sep 07, 2008 at 03:21:18PM -0700, Jeremy Fitzhardinge wrote:
>   
>> __acpi_map_table() effectively reimplements early_ioremap().  Rather
>> than have that duplication, just implement it in terms of
>> early_ioremap().
>>
>> However, unlike early_ioremap(), __acpi_map_table() just maintains a
>> single mapping which gets replaced each call, and has no corresponding
>> unmap function.  Implement this by just removing the previous mapping
>> each time its called.  Unfortunately, this will leave a stray mapping
>> at the end.
>>     
>
> It would be better to just fix the ACPI code to unmap.

I was concerned that would cause lots of cross-arch churn, but of course
the only other relevant architecture is ia64.  I'll prep a followup patch.

    J
