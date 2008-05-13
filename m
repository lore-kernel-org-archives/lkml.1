Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYEMIzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYEMIzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbYEMIzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:55:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:59813 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbYEMIzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mHfntwMzTPZnRNOnAj0SDii54iQJ2C1xjSpRYBB/EzTKjEFfS7X9QFkYrRO/MYMuI0aAoUywSrwR/ozymv1Vk5ANLKzzSmAGI8Pw4wTu+M+WF5kOZM9a38+wYT7rNI52BSX1EOEiMPDSbx4sN3F+w6SLz0MzGMA2OeyLDm3/Psc=
Message-ID: <48295773.9030301@gmail.com>
Date: Tue, 13 May 2008 17:55:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harald Arnesen <skogtun.linux@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [Bisected] Latest git will not boot on MacBook
References: <8120cfd40805100705keff68a2kb117aab7d64f76ff@mail.gmail.com>
In-Reply-To: <8120cfd40805100705keff68a2kb117aab7d64f76ff@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Arnesen wrote:
> See attached photo of screen.
> git bisect gives this:
> 
> 
> 78ab88f04f44bed566d51dce0c7cbfeff6449a06 is first bad commit
> commit 78ab88f04f44bed566d51dce0c7cbfeff6449a06
> Author: Tejun Heo <htejun@gmail.com>
> Date:   Thu May 1 23:41:41 2008 +0900
> 
>     libata: improve post-reset device ready test
> 
>     Some controllers (jmb and inic162x) use 0x77 and 0x7f to indicate that
>     the device isn't ready yet.  It looks like they use 0xff if device
>     presence is detected but connection isn't established.  0x77 or 0x7f
>     after connection is established and use the value from signature FIS
>     after receiving it.
> 
>     This patch implements ata_check_ready(), which takes TF status value
>     and determines whether the port is ready or not considering the above
>     and other conditions, and use it in @check_ready() functions.  This is
>     safe as both 0x77 and 0x7f aren't valid ready status value even though
>     they have BSY bit cleared.
> 
>     This fixes hot plug detection failures which can be triggered with
>     certain drives if they aren't already spun up when the data connector
>     is hot plugged.
> 
>     Tested on sil, sil24, ahci (jmb/ich), piix and inic162x combined with
>     eight drives from all major vendors.
> 
>     Signed-off-by: Tejun Heo <htejun@gmail.com>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

The change was reverted and I'm trying to come up with a better version. 
  Thanks.

-- 
tejun
