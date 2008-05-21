Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbYEUB0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbYEUB0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbYEUB0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:26:04 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:27837 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbYEUB0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BYVkPSf/xJrH63xMvlacfuqr2XYfZDYHs50Zg9CZzX3YF0q5KdQb0lsHOFgzvC3mDkTtcYEnHGOGbggx2x5pNWsIhXyk1qwVOZ8LdT3y3bjDx+8WX4Sie4cAvAzPvFmOiHqwGvgQuKnNZY1FNFPWu2vvH2IVGzjAnXxkTgFYTSc=
Message-ID: <a8e1da0805201825w4c8e35d7o55db8af9e04981df@mail.gmail.com>
Date: Wed, 21 May 2008 09:25:58 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Cc: akpm@linux-foundation.org, matthew@wil.cx, kay.sievers@vrfy.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080520172259.GB11666@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
	 <20080520172259.GB11666@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:22 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 20, 2008 at 05:58:51PM +0800, Dave Young wrote:
>> [Please first apply the patch 1/3 before this]
>>
>> To please lockdep here we use class_reclassify to change
>> the lock class of sg_sysfs_class
>
> Are you suggesting we do this for every struct class in the kernel?  If
> so, why not just do it in the class core, instead of having to modify
> every single caller?

I don't think it necessary to do this for every class, because only
class_interface_* calls could cause the issue, and the
class_interface_* are only used by pcmcia & scsi, do you think there
will be other users of them?

>
> I don't think the overall idea of this patch set is acceptable anyway :(
>
> thanks,
>
> greg k-h
>
