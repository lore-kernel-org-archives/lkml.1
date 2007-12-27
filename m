Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXL0BZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXL0BZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 20:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXL0BZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 20:25:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXL0BZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 20:25:10 -0500
Message-ID: <4772FE1E.3040401@zytor.com>
Date: Wed, 26 Dec 2007 17:21:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Pavel Machek <pavel@ucw.cz>, Julia Lawall <julia@diku.dk>,
       tglx@linutronix.de, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk> <20071226194718.GB8844@elf.ucw.cz> <4772F972.7070802@zytor.com> <20071227011712.GG27894@ZenIV.linux.org.uk>
In-Reply-To: <20071227011712.GG27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Dec 26, 2007 at 05:01:38PM -0800, H. Peter Anvin wrote:
> 
>> The right way to do it is:
>>
>> 	memset(&info.vm86plus, 0, sizeof info.vm86plus);
> 
> If it's just one field _and_ we don't have padding we want to zero out -
> certainly...

It is - [comments removed for clarity]:

struct kernel_vm86_struct {
         struct kernel_vm86_regs regs;
#define VM86_TSS_ESP0 flags
         unsigned long flags;
         unsigned long screen_bitmap;
         unsigned long cpu_type;
         struct revectored_struct int_revectored;
         struct revectored_struct int21_revectored;
         struct vm86plus_info_struct vm86plus;
         struct pt_regs *regs32;
};
