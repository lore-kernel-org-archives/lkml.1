Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbYHaPJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbYHaPJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 11:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYHaPIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 11:08:48 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:52190 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYHaPIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 11:08:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=JM/d5TfPbwKsNgPdyLy9Tsg/uZxy/ZyqA+oIA/29jn9xaSqJXbJrx+60a22N7cclpOdXxzf2ArICxl+HyT5cjY7qZ3XGFTG2fGyu1uIePjxzDkuvCTiVAGuToj828vw3;
Message-ID: <48BAB3FB.1050809@simon.arlott.org.uk>
Date: Sun, 31 Aug 2008 16:08:43 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
References: <48B9546B.4010004@simon.arlott.org.uk>	 <1220117091.3615.3.camel@localhost.localdomain>	 <20080830174516.GD1239@parisc-linux.org>	 <48B9B552.8060406@simon.arlott.org.uk>	 <48B9B588.7060709@simon.arlott.org.uk> <1220147947.3615.18.camel@localhost.localdomain>
In-Reply-To: <1220147947.3615.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/08 02:59, James Bottomley wrote:
> On Sat, 2008-08-30 at 22:03 +0100, Simon Arlott wrote:
>> The capacity printk'd in bytes is divided by 1000000,
>> whereas 1048576 would be more consistent with the rest
>> of the OS and disk-related utilities ('df' etc.).
>> 
>> This change replaces the (sz - (sz/625 - 974))/1950
>> calculation with a simple right shift to output with
>> five significant digits the capacity in KB, MB, GB, TB,
>> PB, or EB. Anything beyond this becomes too large...
> 
> Well, still needs to be dividing by 1000 not 1024 for SCSI and ATA.
> However, I'm afraid it needs to be a bit more sophisticated:  for
> instance, under these calculations, a 1.75TB disk will show up as 1TB.
> Thus, I think we need to print the capacity to 3 significant figures to
> cope with this case.

Actually it'll show up as 1629GB, as my patch shows up to 5 digits 
(not five significant digits, which would require outputting a 
non-integer value).

Isn't outputting "1.75" unnecessarily complicated, and "1750" would 
work better?

-- 
Simon Arlott
