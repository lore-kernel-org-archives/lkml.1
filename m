Return-Path: <linux-kernel-owner+w=401wt.eu-S936773AbYECAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936773AbYECAna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYECAnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:43:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbYECAnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:43:21 -0400
Message-ID: <481BB512.6030101@zytor.com>
Date: Fri, 02 May 2008 17:42:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: "Moore\, Eric" <Eric.Moore@lsi.com>, linux-kernel@vger.kernel.org
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com> <ada63tw494z.fsf@cisco.com>
In-Reply-To: <ada63tw494z.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Is a 64bit write to MMIO registers an atomic operation when using the
>  > writeq API?  
>  > 
>  > My concern is when I send 64bit data via writeq, will it be sent out as
>  > two 32 bit writes?  If so, is it possible that another CPU be sending
>  > the data at the same time.  Meaning can I write the 1st 32bit data from
>  > CPU-A, meanwhile CPU-B is writing his 32bit data at the same time, and
>  > CPU-A didn't complete the full 64bit in one shot.  If this could occur,
>  > is there an API that I can use to make sure the entire data sent in one
>  > atomic operation?
> 
> I don't have an authoritative answer, but I can say that I coded
> drivers/infiniband/hw/mthca and .../mlx4 assuming that writeq() is
> atomic in the sense that you say, and no one has reported any problems.
> 

If you're not under lock you're screwed on a 32-bit platform.

	-hpa
