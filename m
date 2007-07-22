Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXGVS5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXGVS5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762145AbXGVS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:57:30 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:33760
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760888AbXGVS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:57:29 -0400
Date: Sun, 22 Jul 2007 11:56:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Power Management framework proposal
In-Reply-To: <1185125189.2714.13.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
 <1185125189.2714.13.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Arjan van de Ven wrote:

>> this approach would allow the transition of ALL drivers to the new mode of
>> operation in one fell swoop, and then adding additional power management
>> features is just adding to the existing list rather then implementing new
>> functions.
>
>
> I have a concern with this approach though. It seems to assume that
> there is one global thing somewhere that sets the system state; in my
> experience that is the wrong approach; in fact there is a very definite
> evidence that there are many decisions on power that are to be made
> local at a high frequency. An example of this is the processor speed;
> the ondemand governer does exactly this for the cpus that can switch
> speeds fast; it's just impossible to beat such a local, fast decision
> with anything on a global scale.

the intent was not to have one global call that sets the mode on all 
devices, but rather have one call for each device/subsystem, just the same 
call in each case.

there's also nothing that says that there can only be one thing setting 
the mode (although that does mean a fourth call 'report_current_mode()' or 
similar is needed). and if you choose to have two pieces of software 
managing the same device things could get 'interesting'.

as for the speed that such decisions need to be made.

this API is not saying anything about the speed of the decisions.
it's also not saying anything about if the decision makeing is being done 
by kernelspace or userspace. it's just providing a common way for whatever 
software is doing the decision makeing to find out it's options and set 
the modes.

one way to represent this in sysfs (as a possible userspace API) would be
power/mode (read to see what mode the device is in, write to set the mode)
power/modelist
power/switching_delay (outputs the delay matrix showing the cost of switching from mode to mode)
although I'm not sure how you would allow the system to report an error 
this way.

if you have the ondemand governer running, it uses these API's to make 
it's changes, but if you didn't want to run the ondemand governer you 
could just do course speed settings through sysfs.

> On the other hand, some things (the high level goals and constraints)
> are obviously global.
>
> However, your design seems to want to put the low level settings in a
> global thing, and that is just a mistake.

I'm proposing a single function name per device, not a single function for 
the entire system.

David Lang
