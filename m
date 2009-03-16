Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZCPWkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZCPWkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZCPWjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:39:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZCPWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:39:54 -0400
Message-ID: <49BED431.5070201@zytor.com>
Date: Mon, 16 Mar 2009 15:35:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org> <49BEAD27.3050801@kernel.org> <49BEAFEC.7020400@goop.org> <49BEB5FE.7050601@zytor.com> <49BEBD98.3090905@goop.org> <49BEC143.6030104@zytor.com> <49BEC53F.20200@goop.org>
In-Reply-To: <49BEC53F.20200@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Or simplified:
>>
>> PAGE_TABLE_SIZE(((1 << 32)-PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> 
> Was worried about 1<<32 overflowing.  Never really sure what gas's type 
> system is.
> 

It's bignum-based.

You could also write:

PAGE_TABLE_SIZE((-PAGE_OFFSET & 0xffffffff) >> PAGE_SHIFT) << PAGE_SHIFT

(the & 0xffffffff is necessary, or you'll get a signed shift.)

	-hpa
