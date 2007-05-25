Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbXEYMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbXEYMwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762488AbXEYMwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:52:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:16994 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762478AbXEYMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tJpIxfyEVnuR/arXTpxc4w8FGxV5vWh8YqXzS4pDorc9LNVdszbIaWVLLyt3+KcpwQj5O1Jfuqr0inrcEj20sS1XeCCvySiGw2DeC5kF288gYGbRLCDQCDnJoKIR/nPe0orCIU61Iw2qYGMtU26+qyNj3TnLSyltkwUItf9T7Is=
Message-ID: <4656DBF6.6060204@gmail.com>
Date: Fri, 25 May 2007 14:52:06 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: always use polling SETXFER
References: <20070314053338.GA15600@htj.dyndns.org> <4656C144.2080705@garzik.org> <4656CF83.5020402@gmail.com> <4656D602.3010105@garzik.org>
In-Reply-To: <4656D602.3010105@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> So, I don't think the problem exists for SATA in the first place.  At
>> least there hasn't been any report of it and doing SETXFER by polling
>> can handle all the existing cases.  We can and probably should deal with
>> such SATA devices when and if they come up.  How are we gonna verify the
>> controller doesn't crap itself and ahci TF register monitoring HSM can
>> work around the weirdo when we don't have any such device?  Even if we
>> determine that we need to do HSM over intelligent SATA controller now, I
>> think we still need to push polling SETXFER first to take care of the
>> existing cases.
> 
> Doing SETXFER by polling only handles the cases where the driver
> actually honors ATA_TFLAG_POLLING, which is /not/ always the case.
> 
> If the new policy ensures that it continues to be OK to /not/ honor
> ATA_TFLAG_POLLING -- thus limiting SETXFER polling assumptions to older
> hardware -- that's fine, and it merely needs to be documented.

Basically this flag applies to drivers which is SFF compliant, at least
at TF interface level.  There also are other flags/callbacks which only
apply to SFF or BMDMA.  It would be nice to separate them out in the
long term and yeah it needs documentation.

> But let us not make the assumption that this bandaid fixes all cases,
> because the bandaid is not applied in all cases.

It covers all the known cases but I agree that SFF specific things
certainly need documentation.

Thanks.

-- 
tejun
