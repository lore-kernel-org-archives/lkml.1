Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYHYKg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYHYKg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYHYKgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:36:46 -0400
Received: from il.qumranet.com ([212.179.150.194]:26712 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYHYKgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:36:45 -0400
Message-ID: <48B28B3B.6010004@qumranet.com>
Date: Mon, 25 Aug 2008 13:36:43 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] Fix emergency_restart (sysrq-b) with kvm loaded on	Intel
 hosts
References: <1219655506-27418-1-git-send-email-avi@qumranet.com> <20080825091508.GC9114@elte.hu> <48B27AFE.3080704@qumranet.com> <20080825093020.GA5617@elte.hu> <48B28367.2040500@qumranet.com> <20080825102714.GA15810@elte.hu>
In-Reply-To: <20080825102714.GA15810@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>> reboot was always a bit fragile - i think we should only do that if 
>>> we find a box where the FADT reset works better than the first-wave 
>>> approaches we try.
>>>       
>> It worked on my host.  Since it will fall back to keyboard reset and 
>> triple fault, it seems fairly safe.
>>     
>
> ... except if it hangs in ACPI/SMM code for whatever reason.
>   

acpi reboot doesn't call into the aml interpreter.  It just bangs on a 
port that it reads from a static table.  See acpi_reboot().

It's true that SMM could be set up to intercept that port, but in that 
case, it is even more likely that it intercepts the keyboard controller 
port (to translate usb keyboards etc).

-- 
error compiling committee.c: too many arguments to function

