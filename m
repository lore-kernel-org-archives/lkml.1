Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZDMRKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZDMRKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZDMRKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:10:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36386 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZDMRKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:10:43 -0400
Message-ID: <49E3720C.8060008@mvista.com>
Date: Mon, 13 Apr 2009 10:10:36 -0700
From: Dave Jiang <djiang@mvista.com>
Organization: MontaVista Software, Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Haran <jharan@Brocade.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check() ?
References: <57AC2FA1761300418C7AB8F3EA493C9702C5F200@HQ-EXCH-5.corp.brocade.com> <20090410144715.0fa5939e.akpm@linux-foundation.org>
In-Reply-To: <20090410144715.0fa5939e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, you are correct. I will submit a patch to correct that.

Andrew Morton wrote:
> (cc's added)
> 
> On Wed, 8 Apr 2009 14:57:42 -0700
> "Jeff Haran" <jharan@Brocade.COM> wrote:
> 
>> Hi,
>>
>> Recent versions of this function start off with:
>>
>> static void mpc85xx_mc_check(struct mem_ctl_info *mci)
>> {
>>     struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
>>     ...
>>
>>     err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
>>     if (err_detect)
>>         return;
>>
>>     ...
>> }
>>
>> My reading of the Freescale 8548E Manual leads me to conclude that the
>> Memory Error Detect register (ERR_DETECT) will have various bits set if
>> the memory controller has detected an error since the last time it was
>> cleared. If no memory error has occurred, the register will contain 0.
>>
>> Perhaps I am missing something very basic, but it seem to me that the
>> above "if" should be:
>>
>>     if (!err_detect)
>>         return;
>>
>> as the existing code would seem to read "if any errors have occurred,
>> ignore them", though perhaps testing has demonstrated that the Freescale
>> manual is in error.
>>
>> Please include this email address in responses as I do not subscribe.
>>
>> Thanks,
>>
>> Jeff Haran
>> Brocade
> 


-- 

------------------------------------------------------
Dave Jiang
Software Engineer
MontaVista Software, Inc.
http://www.mvista.com
------------------------------------------------------

