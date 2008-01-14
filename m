Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYANQ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYANQ1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYANQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:27:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:48469 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYANQ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=t0beiHjXSOUsiCQkcYKxlWjh3u8NhfiXPNylJQC9OCp/WJr7xVko5Ghzja06+ee2sbom7MY03gRp5N8nrXeazqAy0RNimU6FlDCr4HIQeX0QNUABhVMgJb1b02BT/8J8PzC2G8ITrf03UoOiWugLepiSdkGCR2ANKFBHFRYa12g=
Message-ID: <478B8D54.7010400@gmail.com>
Date: Mon, 14 Jan 2008 17:27:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com> <478A82AD.3070904@gmail.com> <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com> <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com> <478B7C4A.5090903@gmail.com> <20080114153806.GA6639@cvg> <478B86DA.1010902@gmail.com> <20080114160745.GB6639@cvg>
In-Reply-To: <20080114160745.GB6639@cvg>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2008 05:07 PM, Cyrill Gorcunov wrote:
> Yes, process would be stopped, and not *just* stopped but could spend
> all his cpu time-slice in attempt to get spinlock (espec if set time is
> much longer than read), but if we use mutex here the process could just
> sleep instead of trying to get spinlock granted. Am I wrong? Or this is
> not worth to do it?

I would say no. It'll spin only for nanoseconds there.
