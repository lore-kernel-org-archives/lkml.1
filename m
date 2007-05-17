Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXEQNXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXEQNXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbXEQNXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:23:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:53854 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbXEQNXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:23:34 -0400
Message-ID: <464C574C.5020201@qumranet.com>
Date: Thu, 17 May 2007 16:23:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: strange GPF when panicing under kvm
References: <464B9E19.6050902@goop.org>
In-Reply-To: <464B9E19.6050902@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> When I boot 2.6.22-rc1-mm1 under kvm, but forget to specify a root
> filesystem, it panics as expected.  However, when panicing, it gets a
> GPF in delay_tsc, and then starts recursively panicing.
>
> I don't really understand what's going on; the instruction it's faulting
> on seems to be "pause" (ie, rep;nop), which seems like it shouldn't
> fault at all.  It looks like some kvm artifact to me, but I'm not sure.
>
> Hm, given the error code, maybe it's a segment register problem.
>
>   

Strange.  What does your msr 0x482 look like?  If you have 
/dev/cpu/0/msr, the following will spit it out:

-------------
#!/usr/bin/python

import struct

msrs = file('/dev/cpu/0/msr')
msrs.seek(0x482)
msr = msrs.read(8)
msr = struct.unpack('Q', msr)[0]

print '%x' % (msr,)
----------------

(that msr can force trapping of the pause instruction, even though 
there's no good reason to do it, and kvm wouldn't inject a gp if it did 
anyway).

-- 
error compiling committee.c: too many arguments to function

