Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbZDSQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbZDSQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbZDSQXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:23:44 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:25866 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760650AbZDSQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:23:43 -0400
X-IronPort-AV: E=Sophos;i="4.40,213,1238976000"; 
   d="scan'208";a="156352910"
Message-ID: <49EB5008.1090000@cisco.com>
Date: Sun, 19 Apr 2009 09:23:36 -0700
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Wait for console to become available, v2
References: <20090416190837.GA26734@cuplxvomd02.corp.sa.net> <874owlqcce.fsf@basil.nowhere.org>
In-Reply-To: <874owlqcce.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> VomLehn <dvomlehn@cisco.com> writes:
>> History
>> v2	Wait for the preferred console rather than any console. Make the
>> 	delay interval a tunable.
> 
> CONFIG tunables are usually a bad idea. What should a binary distribution
> kernel set? Better make it a boot option with a reasonable default.

Your point about boot options is well taken; I released a more recent 
version of this patch with boot options last Friday and would appreciate 
your comments.

> Also a setting to panic in this case might be useful, normally a system
> without console is not very useful and needs to be rebooted anyways.

Umm, those of us in the embedded space have the, perhaps misguided, 
notion that our systems are quite useful without consoles...

But, more to the specific point, the console code is pretty smart. If 
you set your delay interval too short and the console comes up later, 
you won't see output to /dev/console, but you *will* see kernel printk 
output, including the message that no console could be opened. This 
would, hopefully, point the user to the problem. I can also make the 
message more specific about which parameter to set in that case.

> 
> -Andi


