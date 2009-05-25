Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbZEYIdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbZEYIdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZEYIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:33:12 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57901 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZEYIdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:33:11 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d" as interface name
Date: Mon, 25 May 2009 10:33:08 +0200
User-Agent: KMail/1.9.10
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <alpine.DEB.2.01.0905232309400.7424@bogon> <tkrat.6c3758bf0544a790@s5r6.in-berlin.de>
In-Reply-To: <tkrat.6c3758bf0544a790@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251033.09272.zzam@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 24. Mai 2009, Stefan Richter wrote:
> Christian Kujau wrote at LKML:
> > If the patch will be accepted at all and it's not too late to ask: I'd
> > vote for fw%d as well, "firefire" just looks too long, for me at least.
>
> I think I'll leave the driver as it is.
> As I just noticed, we would lose interface renaming by udev.
> From udev/extras/rule_generator/75-persistent-net-generator.rules:
>
>   # device name whitelist
>   KERNEL!="eth*|ath*|wlan*[0-9]|msh*|ra*|sta*|ctc*|lcs*|hsi*",
> GOTO="persistent_net_generator_end"
>
> Besides, if we can we should avoid fw%d because this will clash with
> udev rules which match KERNEL=="fw*", as in
> udev/rules/redhat/40-redhat.rules.

I suggest a subsystem match here, or generally some
SUBSYSTEM!="net", GOTO="end_of_file"
around almost all rule files that should not match on network interfaces, as 
users can rename them to almost all crazy names.

@Kay: Perhaps it could simplify some rulesets to have a special jump target or 
option to skip entiere rules files.

Regards
Matthias
