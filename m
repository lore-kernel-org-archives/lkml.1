Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbXJROiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbXJROiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXJROiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:38:22 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:36771 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbXJROiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:38:20 -0400
Message-ID: <47176FDA.2060406@tiscali.nl>
Date: Thu, 18 Oct 2007 16:38:18 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl> <20071017143240.GH8181@ftp.linux.org.uk>
In-Reply-To: <20071017143240.GH8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Oct 17, 2007 at 03:46:43PM +0200, Roel Kluin wrote:
>> +++ b/drivers/misc/asus-laptop.c
>> @@ -322,7 +322,7 @@ static void write_status(acpi_handle handle, int out, int mask)
>>  
>>  	switch (mask) {
>>  	case MLED_ON:
>> -		out = !out & 0x1;
>> +		out = !(out & 0x1);
> 
> Not sure if that's what had been intended.

It seems to me if I look at the code, that it's intended to make a bool out of 'out'. That's
nonsense because of the precedence the ! will turn it into a boolean before the & 0x1.

x = !x & y behaves like x = !x for y != 0. 
for y = 1 the behavior is even the same for x = !(x & y)
so it does not matter in this case, except for clarity. I'll make it out = !out.

> 
>> @@ -2882,7 +2882,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
>>  			    !(STp->use_pf & PF_TESTED)) {
>>  				/* Try the other possible state of Page Format if not
>>  				   already tried */
>> -				STp->use_pf = !STp->use_pf | PF_TESTED;
>> +				STp->use_pf = !(STp->use_pf | PF_TESTED);
> 
> Wrong.  This code, ugly as it is, happens to be correct.  Replacement
> isn't.  I would rewrite it as ^= PF_TESTED | USE_PF; /* remove USE_PF, set *
> 						      * PF_TESTED */
> 
> The rest is covered by Alexey's patch and one I'd posted as followup.


ok, thanks, I'll correct and omit these in my follow up patch.

Roel
