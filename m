Return-Path: <linux-kernel-owner+w=401wt.eu-S1750743AbXBMPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750743AbXBMPaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbXBMPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:30:18 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:42792 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXBMPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:30:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FbwnwSnnV/7zOFJJ7TvkcrlJgLzu4ITrG5MDqu9ByDnPpLfy/1IBnxjFk5QMM8xNgdC5fynn9SwVZ4HCeIewrEfE+YNYf5ljAOIjW065HC7o0nbTmqLe+G5iy0EnA6R9tsm28MCwt0TQNL2Sq8Fw6jILBVbhxW2LKTO2S3dxTTQ=
Message-ID: <45D1D97B.6010002@gmail.com>
Date: Tue, 13 Feb 2007 07:30:03 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: pcim_enable_device BUGs for libata devices in 2.6.20-git6
References: <45CFB87F.9060802@shaw.ca> <45D02F5B.801@gmail.com> <20070212205444.GC18101@elf.ucw.cz>
In-Reply-To: <20070212205444.GC18101@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

Pavel Machek wrote:
>> 1. Don't restore power state and re-enable PCI device on resume from 
>> freeze just as we don't do the opposite when freezing.
>>
>> 2. Unconditionally disable and power down PCI device on suspend whether 
>> it's freeze or not.
>>
>> #2 would be simpler but I'm a bit worried about it.  There might be 
>> controllers which choke after such sequence (save state, disable, power 
>> down, no actual power removal, power on, restore state, re-enable).
> 
> I'd just go for #2.

I think I've been seeing too many weird ATA controller issues to be bold 
about this.  I'll chicken out and go for #1.  :-)

>> #1 can be easily done by taking a look at the current device power state 
>> (gendev->power.power_state).  The problem is that no one in 
>> suspend/resume path seems to be setting that variable except for
>> runtime 
> 
> No, that variable is probably going to go away. If you want to
> remember that you are resuming from freeze, just store that info in
> private data structure.

I see.  Thanks.

-- 
tejun
