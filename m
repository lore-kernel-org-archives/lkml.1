Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZAFPVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZAFPVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZAFPU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:20:56 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:40921 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZAFPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KKUofWqIP+0sF491VdMNIT06jL6IOQN7S4QNHpcw3OdMCuwxoPIGK196IfxmaTpYGS
         pHbxoNM2//YpCnyUkDD26Q4gho/FNAr9FIruGzKA/uaI4DfdksoeOeQandTANAVEFceI
         fz+fuNqw+u37cM9sG6k4xW354NZ0WNow8F3Ts=
Message-ID: <8bd0f97a0901060720l40099bd6o63a692e5fdd3e098@mail.gmail.com>
Date: Tue, 6 Jan 2009 10:20:54 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: debugfs & vfs file permission issue?
Cc: "Greg KH" <gregkh@suse.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <200901061012.38888.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901052157.07306.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0901052232l22b60386pbcd9438cc752638f@mail.gmail.com>
	 <200901060705.33294.rgetz@blackfin.uclinux.org>
	 <200901061012.38888.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 10:12, Robin Getz wrote:
> On Tue 6 Jan 2009 07:05, Robin Getz suggested:
>> adding a readonly, and writeonly, and ensuring that when you call
>> debugfs_create_*, the mode is checked, and the "correct" fops are set
>> doesn't seem like it would be a bad idea? This would enforce the
>> kernel programmer's view on the world, and not allow pesky root users
>> to override things....
>>
>> Greg - would you take something like that?
>
> How about this?
>
> Feel free to nak it - we can do the same thing where we are calling the
> debugfs_create_* functions - this just makes it cleaner in my opinion.
>
> ---
>
> In many SOC implementations there are hardware registers can be read only,
> or write only. This extends the debugfs to enforce the file permissions for
> these types of registers, by providing a set of fops which are read only
> or write only. This assumes that the kernel developer knows more about the
> hardware than the user (even root users) - which is normally true.

we want it for cpu registers, but i dont see any reason why this
wouldnt also apply to external devices attached via memory interfaces
... fifos and such ...
-mike
