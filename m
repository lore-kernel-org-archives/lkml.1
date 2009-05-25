Return-Path: <linux-kernel-owner+w=401wt.eu-S1751274AbZEYK6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbZEYK6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZEYK6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:58:15 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:53783 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZEYK6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:58:14 -0400
MIME-Version: 1.0
In-Reply-To: <200905251033.09272.zzam@gentoo.org>
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <alpine.DEB.2.01.0905232309400.7424@bogon> 
	<tkrat.6c3758bf0544a790@s5r6.in-berlin.de> <200905251033.09272.zzam@gentoo.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 25 May 2009 12:57:54 +0200
Message-ID: <ac3eb2510905250357qd72b0eel7cec2bd56f12f71@mail.gmail.com>
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d" as 
	interface name
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-hotplug@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 10:33, Matthias Schwarzott <zzam@gentoo.org> wrote:
> On Sonntag, 24. Mai 2009, Stefan Richter wrote:
>> Christian Kujau wrote at LKML:
>> > If the patch will be accepted at all and it's not too late to ask: I'd
>> > vote for fw%d as well, "firefire" just looks too long, for me at least.
>>
>> I think I'll leave the driver as it is.
>> As I just noticed, we would lose interface renaming by udev.
>> From udev/extras/rule_generator/75-persistent-net-generator.rules:
>>
>>   # device name whitelist
>>   KERNEL!="eth*|ath*|wlan*[0-9]|msh*|ra*|sta*|ctc*|lcs*|hsi*",
>> GOTO="persistent_net_generator_end"
>>
>> Besides, if we can we should avoid fw%d because this will clash with
>> udev rules which match KERNEL=="fw*", as in
>> udev/rules/redhat/40-redhat.rules.
>
> I suggest a subsystem match here, or generally some
> SUBSYSTEM!="net", GOTO="end_of_file"
> around almost all rule files that should not match on network interfaces, as
> users can rename them to almost all crazy names.
>
> @Kay: Perhaps it could simplify some rulesets to have a special jump target or
> option to skip entiere rules files.

Not sure, if Fedora is using this rule file, there seems a lot of old
stuff in it. But the rule should be ignored for device without a
device node, when SYMLINK is given in the rule.

Kay
