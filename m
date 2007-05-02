Return-Path: <linux-kernel-owner+w=401wt.eu-S2993049AbXEBLaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993049AbXEBLaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993051AbXEBLaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:30:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:1698 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993049AbXEBLaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jKHUOcLt8TbkIQTFdU3Y6p8ir4tS/7G9LZIch99f891geFY1sxFJGb1pWYPA4OwGtEx1PZ2vB7p4/LPvxxDPB1rueX2K1SZSOEfvsjeYikeTuhQ1qDTmqyJVjDVNZNVdjtouLz7PsX2BJGYnnwzDASbw/hx1rZBJIz5k9w/miEQ=
Message-ID: <46387601.4010403@gmail.com>
Date: Wed, 02 May 2007 13:29:05 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] sysfs: implement bin_buffer
References: <11777675753460-git-send-email-htejun@gmail.com>	 <1177767582628-git-send-email-htejun@gmail.com>	 <a781481a0705010725t310ecb31yde475412f620d6d6@mail.gmail.com>	 <463753DB.2060101@gmail.com>	 <a781481a0705011237n791f7cafn54509c1a41cf3de6@mail.gmail.com> <a781481a0705011304mb8b33faq4afc67363ac79c8d@mail.gmail.com>
In-Reply-To: <a781481a0705011304mb8b33faq4afc67363ac79c8d@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> Yes, I saw that, but you could change it just as well. In any case,
>> this will only make fs/sysfs/bin.c similar to what is being done in
>> fs/sysfs/file.c. We allocate the buffer page backing the attribute's
>> data in fill_read_buffer() and fill_write_buffer() using
>> get_zeroed_page() and not kzalloc().
> 
> Which begs another question -- why do we allocate the buffer page
> lazily (only at the time of read(2) and write(2) and not at open(2))
> in the case of normal attributes but prefer to do it during open(2)
> itself for binary attributes? Note that the page (if allocated) is
> freed during release() for both cases.

Well, that also is because that was how bin files did it before the
patch.  I don't object to any of your suggestions but also thinks that
they are better off as separate patches.  So, feel free to submit patches.

-- 
tejun
