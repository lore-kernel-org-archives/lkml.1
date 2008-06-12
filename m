Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYFLXAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYFLXAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYFLW7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:59:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYFLW7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:59:52 -0400
Message-ID: <4851AA4C.4070001@zytor.com>
Date: Thu, 12 Jun 2008 15:59:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
References: <20080612223802.528617000@polaris-admin.engr.sgi.com> <20080612223802.673729000@polaris-admin.engr.sgi.com> <4851A639.6040405@zytor.com> <4851A935.3010705@sgi.com>
In-Reply-To: <4851A935.3010705@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> We could.  My current debugging is in x86_64_start_kernel() almost at
> the start of the function (before the "Kernel alive" message).  The
> code is below.  (cut and pasted so no tabs)
> 
> One benefit of a startup option instead of a config option  is we rely
> on the standard distribution for the kernel and unless they set this
> option it won't do us much good.
> 
> (Maybe the failed attempts was trying to tell me something? ;-)
> 

The easiest way to get to something extremely early is to parse it out 
already in the setup code and pass in a flag in struct boot_params. 
Otherwise, the kernel command line is present in memory and can be 
copied or parsed in an ad hoc manner.  For i386 it is copied in place 
already in the assembly code -- for x86-64 it looks like we could 
trivially move copy_bootdata until just past clear_bss().

	-hpa
