Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbYCGANd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbYCGANd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYCGANV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:13:21 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:2075 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYCGANV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:13:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iADGttA2hN7hstNIPfS7PPkFvA4pCxzqT+D8xminnXNlYHaUCWaSZlmCxCQgotSfYBOaReIV85UJu2DkfNA/GtUwFWBTr/yCUtEQvqRnEwJdquZf3UkntIuwOIry1x/QPSeqR5xOGKALiXLWKVjt16cu9Xrxu0+x1ra5ClZWj7g=
Message-ID: <47D08892.3080209@gmail.com>
Date: Fri, 07 Mar 2008 09:13:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: ata_ram driver
References: <20080222200951.GI16995@parisc-linux.org>	 <47BF3E54.9050609@rtr.ca>  <47CFA9A6.2040506@gmail.com>	 <1204817301.3062.3.camel@localhost.localdomain>	 <47D08478.8010700@gmail.com> <1204848119.3062.94.camel@localhost.localdomain>
In-Reply-To: <1204848119.3062.94.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> * Driver unload: Dealt the same way as hot unplugging.
> 
> This is the problem case: driver unloading should have a
> scsi_remove_host() in its path.  This is the trigger that sends out the
> flushes/stops and calls slave_destroy.  scsi_remove_host() doesn't
> actually return until all the destroys are completed, so it makes module
> unloading wait until everything is properly shut down.
> 
>> Making driver unload like explicit unplug request is possible but it
>> will mean that drives will be spun down on driver unload, which can be
>> annoying to developers. 
> 
> You have a sysfs flag to prevent that, don't you?

Yeap, sure.  It's the combination of things that always made me put this
off.  Is there a function I can call to just shutdown the host instead
of destroying it?

Thanks.

-- 
tejun
