Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbZB0Wh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbZB0Wh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZB0WhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:37:14 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:44051 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZB0WhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=agqMFHErD9IPNnMq4H5h9naeW7Hje0v61n7B7w98ZU8eF8izaTzGRfta/xE6T/r+eD
         goyqHfRtuTRQVFJzrkYAXMQYUNSRGCyQTKdZzlJW/50saExt0BVRkAWiQ7BqlGE2UJ4a
         Mns8IMYChzvVHS7o4W0itAPRv5DuZXwzkeS40=
MIME-Version: 1.0
In-Reply-To: <20090225181611.GL31792@frodo>
References: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
	 <20090225181611.GL31792@frodo>
Date: Fri, 27 Feb 2009 17:37:09 -0500
Message-ID: <8bd0f97a0902271437q7f380e8dl53265832ea240280@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: - kill the compile warning
From: Mike Frysinger <vapier.adi@gmail.com>
To: me@felipebalbi.com
Cc: Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 13:16, Felipe Balbi wrote:
> On Fri, Feb 06, 2009 at 06:23:30PM +0800, Bryan Wu wrote:
>> drivers/usb/musb/musb_core.c:1433: warning: assignment makes pointer
>> from integer without a cast
>>       hw_ep->target_regs = musb_read_target_reg_base(i, mbase);
>>
>> static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase);
>>
>> this is a common bug, but a bug still ?  mbase is a 32/64 bit pointer,
>> but we return a u16 to assign to a pointer ?  seems odd :)
>>
>> So return right pointer in the stub.
>>
>> Cc: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> any new version coming ??

so we're all on the same page ...

we agree the first hunk is redundant as MUSB_BUSCTL_OFFSET() is an
integer constant and mbase is of the type that is returned.  which
means the first hunk can be dropped.

the 2nd hunk is 100% correct though ...
-mike
