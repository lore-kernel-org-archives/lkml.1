Return-Path: <linux-kernel-owner+w=401wt.eu-S936579AbXFFWqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936579AbXFFWqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934884AbXFFWqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:46:30 -0400
Received: from lucidpixels.com ([75.144.35.66]:54027 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935059AbXFFWq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:46:29 -0400
Date: Wed, 6 Jun 2007 18:46:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <20070606153737.2c9da784.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0706061844240.3563@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
 <200706061528.44070.jesse.barnes@intel.com> <20070606153737.2c9da784.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Randy Dunlap wrote:

> On Wed, 6 Jun 2007 15:28:43 -0700 Jesse Barnes wrote:
>
>> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
>>> Nope, I booted with only netconsole= options.  I have a lot of HW in
>>> the box and I guess the buffer is too small.  Not sure where to
>>> change it in the kernel.  Looking..
>>
>> It's called "kernel log buffer size" and it's in "General setup".
>
> or you can just boot with "log_buf_len=256k" on the kernel boot line (e.g.)
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

Thanks, very useful note!

$ stress --vm 32 --vm-bytes 250M
stress: info: [4087] dispatching hogs: 0 cpu, 0 io, 32 vm, 0 hdd

Mem:   8039576k total,  5288036k used,  2751540k free,       12k buffers
Swap:        0k total,        0k used,        0k free,    37944k cached


$ stress --vm 40 --vm-bytes 250M
stress: info: [4120] dispatching hogs: 0 cpu, 0 io, 40 vm, 0 hdd
Mem:   8039576k total,  6661484k used,  1378092k free,       12k buffers
Swap:        0k total,        0k used,        0k free,    38000k cached

$ stress --vm 42 --vm-bytes 250M
stress: info: [4398] dispatching hogs: 0 cpu, 0 io, 42 vm, 0 hdd
Mem:   8039576k total,  6447048k used,  1592528k free,        8k buffers
Swap:        0k total,        0k used,        0k free,    11148k cached

$ stress --vm 45 --vm-bytes 250M
stress: info: [4352] dispatching hogs: 0 cpu, 0 io, 45 vm, 0 hdd
stress: FAIL: [4372] (494) hogvm malloc failed: Cannot allocate memory
stress: FAIL: [4352] (395) <-- worker 4372 returned error 1
stress: WARN: [4352] (397) now reaping child worker processes
stress: FAIL: [4352] (452) failed run completed in 4s

$ stress --vm 48 --vm-bytes 250M
stress: info: [4303] dispatching hogs: 0 cpu, 0 io, 48 vm, 0 hdd
stress: FAIL: [4323] (494) hogvm malloc failed: Cannot allocate memory
stress: FAIL: [4322] (494) hogvm malloc failed: Cannot allocate memory
stress: FAIL: [4303] (395) <-- worker 4323 returned error 1
stress: WARN: [4303] (397) now reaping child worker processes
stress: FAIL: [4303] (395) <-- worker 4322 returned error 1
stress: WARN: [4303] (397) now reaping child worker processes
stress: FAIL: [4303] (452) failed run completed in 4s

Is there a better way to verify I can use all the available memory?

Justin.
