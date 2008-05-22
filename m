Return-Path: <linux-kernel-owner+w=401wt.eu-S934948AbYEVM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948AbYEVM7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761770AbYEVM7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:59:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45060 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761594AbYEVM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:59:10 -0400
Date: Thu, 22 May 2008 15:07:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86: don't destroy %rbp on kernel-mode faults
Message-ID: <20080522130726.GD31727@one.firstfloor.org>
References: <20080519200230.GA12210@damson.getinternet.no> <4831EE48.5050908@firstfloor.org> <19f34abd0805220507w31e152ar5c9dd04f9774d0e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805220507w31e152ar5c9dd04f9774d0e1@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, I am not sure exactly what a "real unwinder" would be. But I do

A dwarf2 unwinder that doesn't require pipe line stalls on many
CPUs on each function entry point for setting up a frame.  

Instead of letting all code
maintain a frame at runtime the stack frames are described by 
an external unwind table that is then walked by the unwinder.

The unwinder was in for a short time, but 
Linus unfortunately removed it again because it took some time
to debug it in tree and he lost patience. I believe an updated
and stable version is available in the SUSE kernels.

> think it's fair to say that it is the assembly code in this case that
> is violating the binary interface, and not the stack tracer code.

There is a no binary interface for page faults (or other exceptions) 
except that "all registers must be restored in the end". They certainly don't
follow the normal ABI. 

Still the fix is good, just pointing out that you'll likely need
to change a lot more code to get the frame pointer fully supported
everywhere because it was all written under the explicit "no frame pointer" 
assumption.

-Andi (who still prefers the unwinder)


