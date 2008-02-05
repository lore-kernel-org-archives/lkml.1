Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYBEVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYBEVYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYBEVYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:24:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbYBEVYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:24:23 -0500
Message-ID: <47A8D3CF.2080608@zytor.com>
Date: Tue, 05 Feb 2008 13:23:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu> <47A8D088.7050209@zytor.com> <20080205211854.GB27589@uranus.ravnborg.org>
In-Reply-To: <20080205211854.GB27589@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>
>> Technically we should also specify @progbits or @nobits on sections, 
>> however, I think @progbits is the default.
> 
> I have on my todo list to do so. But I wanted to investigate a bit
> more since I do not yet fully understand the difference.
> 
> And we have to use %progbits and %nobits as ARM uses '"' to indicate
> comments.
> 

The difference is quite simple:

	a		- this section occupies address space
	w		- this section is writable
	x		- this section is executable
	progbits	- this section has data in the file

In contrast, a nobits section is implicitly zero-filled.

By default:

.bss 	is (aw,nobits).
.data 	is (aw,progbits).
.rodata	is (a,progbits).
.text	is (ax,progbits).

Since .bss is nobits, it doesn't occupy any space in the executable, and 
is zero-filled by the loader.

	-hpa


