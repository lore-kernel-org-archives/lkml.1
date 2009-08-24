Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbZHXGzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbZHXGzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZHXGzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:55:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37226 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZHXGzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:55:13 -0400
Message-Id: <4A92557002000078000113DD@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 24 Aug 2009 07:55:12 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <sam@ravnborg.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix build with older binutils and
	 consolidate	 linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
 <4A8F0228.80805@zytor.com>
In-Reply-To: <4A8F0228.80805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 21.08.09 22:23 >>>
>On 08/18/2009 08:51 AM, Jan Beulich wrote:
>>  
>>  #define VSYSCALL_ADDR (-10*1024*1024)
>> -#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
>> -                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
>> -#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
>> -                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
>> +#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
>> +                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
>> +#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
>> +                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
>>  
>
>I'm missing something with this chunk... could you please explain?

There are two changes here: One is the adjustment to properly use the
new preceding section's name, and the other is to replace the hard coded
4095 by PAGE_SIZE-1.

Jan

