Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYGVOTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYGVOTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYGVOT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:19:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:36751 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831AbYGVOT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:19:28 -0400
Date: Tue, 22 Jul 2008 08:19:25 -0600
From: Michal Hocko <mstsxfx@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: power@bughost.org, arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Why is /sys/class/power_supply/CMB1/energy_now not exported?
Message-ID: <20080722141925.GA5593@dhcp35.suse.cz>
References: <20080721041213.GA3491@dhcp35.suse.cz> <48841AE3.3000004@suse.de> <20080721165921.GB3491@dhcp35.suse.cz> <4884F98F.4060903@suse.de> <20080722030412.GA5969@dhcp35.suse.cz> <488574CF.7010501@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488574CF.7010501@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 09:49:03AM +0400, Alexey Starikovskiy wrote:
> It looks like you use current_now as power, not multiplying it by voltage.

You are right, my calculation are simply wrong. I have mixed remaining
capacity (calculated for 2.6.25-2 and 2.6.26) with remaining capacity
and some nonsense for the first 2.6.25 (table below was updated).

Nevertheless, what can be the reason for such a different result for
distrbution kernel?

> You should either not multiply anything, then you have similar units -- charge and current,
> or multiply _both_ by voltage_now, then again you have similar units -- power and energy.
> In these both cases you'll have hours or remaining capacity.
>
[...]
>>
>> I have tried 3 configurations:
>> * 2.6.25 - Vanilla kernel with config-2.6.25 config and result output in
>>   powertop-2.6.25-good
>> * 2.6.25-2 - Debian distribution kernel with config-2.6.25-2 config and
>>   powertop-2.6.25-2-bad output
>> * 2.6.26 - Vanilla kernel with config-2.6.26 config and result output in
>>   powertop-2.6.26-good
>>
>> with the following scenario (powertop patched with attached
>> charge-read.patch):
>> * wait for /sys/class/power_class/CMB1/status FULL on AC
>> * get values from all files in ..CMB1 to output file
>> * unplug AC
>> * run powertop
>> * get values from all files in CMB1 again to the same file
>> * get output of power consumption to the output file
>>
>>
>>              |  2.6.25          2.6.25-2        2.6.26
>> ===========================================================================
>> voltage_now  |  12222000        12206000        12218000
>> charge_now   |  4850000         4850000         4850000
>> current_now  |  1398000         1334000         1313000
>> ---------------------------------------------------------------------------
>> reported     |  16.6            1.4             16.3
>> consumption  |
>> ---------------------------------------------------------------------------
   reported     |  3.5             41.7            3.6
   capacity     |
   ---------------------------------------------------------------------------
   calculated   |  3.46            3.63            3.69
   capacity     |
   ===========================================================================
[...]

-- 
Michal Hocko
