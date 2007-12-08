Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXLHD1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXLHD1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXLHD0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:26:53 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:51803 "EHLO
	mail159-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXLHD0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:26:52 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <475A0EF4.1020502@am.sony.com>
Date: Fri, 07 Dec 2007 19:26:44 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <20071205151147.9db4640b.akpm@linux-foundation.org> <47573806.8000808@am.sony.com> <20071206142552.694B.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20071206142552.694B.Y-GOTO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2007 03:26:46.0781 (UTC) FILETIME=[29914AD0:01C8394A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2007 10:09 PM, Yasunori Goto wrote:
>> I'll try Milton's suggestion to pre-allocate the memory early.  It seems
>> that should work as long as nothing else before the hot-plug mem is added
>> needs a large chunk.
> 
> (However, I think Milton-san's suggestion is very desirable. 
>  If preallocation of hotadd works on ia64 too, I'm very glad.)

As it turns out, preallocation is not a such a good solution I
think because in the general case the system may need many
allocations to support the added memory, so it would be difficult
to know how much pre-allocated memory is needed.  I think a
preferable solution is to use memory from the newly added
region.

I don't plan to work on a pre-allocation method.  I think I can
free up sufficient memory in other ways.

-Geoff

