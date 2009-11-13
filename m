Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZKMHaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZKMHaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZKMHaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:30:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZKMHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:30:17 -0500
Message-ID: <4AFD0AFC.5020603@zytor.com>
Date: Thu, 12 Nov 2009 23:30:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Pavel Machek <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <20091112121604.GC1394@ucw.cz> <8FED46E8A9CA574792FC7AACAC38FE7714FEB070EE@PDSMSX501.ccr.corp.intel.com> <4AFCF6D6.6040607@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FEB071DF@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FEB071DF@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 11:23 PM, Ma, Ling wrote:
> Hi H. Peter Anvin
>> What it sounds to me is that for Nehalem, we want to use memcpy_c for >=
>> 1024 bytes and the old code for < 1024 bytes;
> 
> Yes, so we modify memcpy_c as memcpy_new for Nehalem, and keep old
> code for Core2 is acceptable?

No, what I think we should do is to rename the old memcpy to something
like memcpy_o, and then have the actual memcpy routine look like:

	cmpq $1024, %rcx
	ja memcpy_c
	jmp memcpy_o

... where the constant as well as the ja opcode can be patched by the
alternatives mechanism (to a jb if needed).

memcpy is *definitely* frequent enough that static patching is justified.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

