Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYFUAbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYFUAbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 20:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYFUAb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 20:31:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYFUAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 20:31:25 -0400
Message-ID: <485C4B0E.2090704@zytor.com>
Date: Fri, 20 Jun 2008 17:27:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
References: <485C2875.2050204@goop.org>
In-Reply-To: <485C2875.2050204@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi Roland,
> 
> As far as I can work out, an x86_32 kernel will use "int 0x80" and 
> "sysenter" for system calls.  64-bit kernel will use just "syscall" for 
> 64-bit processes (though you can use "int 0x80" to access the 32-bit 
> syscall interface from a 64-bit process), but will allow "sysenter", 
> "syscall" or "int 0x80" for 32-on-64 processes.
> 
> Why does 32-on-64 implement 32-bit syscall when native 32-bit doesn't 
> seem to?  Or am I overlooking something here?  Does 32-bit also support 
> syscall?

The reason is that not all 64-bit processors (i.e. K8) support a 32-bit 
sysenter in long mode (i.e. with a 64-bit kernel.)  sysenter is *always* 
entered from the vdso, since the return address is lost and this is also 
where a 64-bit kernel can put a syscall.

There is no reason we couldn't do syscall for 32-bit native, but the 
only processor that would benefit would be K7, and that's far enough in 
the past that I don't think anyone cares enough.

Note that long mode syscall is different from protected mode syscall, 
even in 32-bit compatibility mode.  The long mode variant is a lot saner.

	-hpa
