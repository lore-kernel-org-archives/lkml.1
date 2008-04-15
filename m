Return-Path: <linux-kernel-owner+w=401wt.eu-S1765486AbYDOW1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765486AbYDOW1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYDOW1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:27:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:27366 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbYDOW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DdECj+GfeOvGQgyarPqevXP7leeD4sZonXIMAfcAnCZuCc+U2YHiUD9EltNCun4YWW5gJ/gX9Bv8PI5fDCU1wiMeJbl9kZe+CI8Y/4nya3SiEAGHgb3LQEVre8cXZTYpTfCZr/zBvy22aCVeABEF0Wgnf6WzcU9KrypSYXzycBo=
Message-ID: <48052BB3.2090509@gmail.com>
Date: Wed, 16 Apr 2008 07:26:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>	<4804288D.5090504@gmail.com> <87y77ex1oh.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87y77ex1oh.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

Paul Collins wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>>> ata2: XXX about to resume
>>> ata2: SATA link down (SStatus 611 SControl 0)
>> The link is already in slumber mode before the driver doing anything
>> to it.  Is there any related setting in BIOS?
> 
> I found a setting labelled "SATA Power Management".  It was set to
> "Enable".  When I set it to "Disable", 2.6.25-rc9 detected the optical
> drive.

This can't be something changed between 2.6.24 and 2.6.25-rc9.  Can you 
please double check that?

>> Also, can you please give a shot at the attached patch?
> 
> I tried this patch with "SATA Power Management" on both settings.  In
> each case it detected the optical drive.

Good, so it seems later ich's need its SPM fields written or link reset 
to get out of powersave mode.  Inhibiting PM modes via IPM isn't enough, 
which BTW is sane.

Jeff, this one looks like another rationale for favoring hardreset over 
softreset && I don't see how we can fix this for 2.6.25.  We can try to 
write to SPM from link_resume() but the field being newly added in SATA 
2.5, I don't feel comfortable about it.

Thanks.

-- 
tejun
