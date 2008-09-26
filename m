Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYIZXal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYIZXal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYIZXac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:30:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:43672 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYIZXab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TbsRScPwXDR3ZPXqxlKEvNUH6JYdnI4i3luLpOpANRPab4uNv/Qd5ZOywWIslNrH6R
         SF+cZQo8mDOF+E+lr1P0t8h6TSQmx7ddNWcm/KmQpq6Iewi9ZTKZ7dk5qTtNlJk7OdAI
         lizRtAB/iY30liFvxlw1d6usNDrdQBEAtIFSU=
Message-ID: <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
Date: Sat, 27 Sep 2008 02:30:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Cc: "Muli Ben-Yehuda" <muli@il.ibm.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Andres Freund" <andres@anarazel.de>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1222441955.3798.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809251511.20132.andres@anarazel.de>
	 <48DC44D4.8000103@garzik.org> <200809260419.07713.andres@anarazel.de>
	 <48DC4BC0.7090203@garzik.org> <20080926144708.GD9118@il.ibm.com>
	 <1222441955.3798.13.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 6:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-09-26 at 17:47 +0300, Muli Ben-Yehuda wrote:
>
>> The way to debug this is to figure out why device 00:1f.2 is trying to
>> read from DMA address fffbf000 and does not have permission to do
>> so. This could be indicative of a driver bug where it is programming
>> the device to read from some buffer that has not been allocated
>> through the DMA API and thus does not have a valid IOMMU mapping, or a
>> hardware quirk where the device tries to read from memory without host
>> involvement. The former is much more likely.
>
> The same is probably true for the iwlagn case which was
>
>> [ 4184.617392] DMAR:[DMA Read] Request device [03:00.0] fault addr fa946000
>> [ 4184.617393] DMAR:[fault reason 06] PTE Read access is not set
>> [ 4184.644081] iwlagn: Microcode HW error detected.  Restarting.
>
> and indeed matches experience from myself and Marcel that DMA bugs seem
> to lurk.

Meanwhile it all reported bugs in this case points to 64 bit
installations, I'll give it more testing
Thnaks.
Tomas
