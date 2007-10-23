Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbXJWRMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbXJWRMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXJWRMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:12:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:37907 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXJWRMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:12:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,318,1188802800"; 
   d="scan'208";a="356028695"
Message-ID: <471E2AD0.1000500@intel.com>
Date: Tue, 23 Oct 2007 10:09:36 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Adam Jackson <ajax@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
References: <11931515302013-git-send-email-ajax@redhat.com>	 <471E1ECD.80002@intel.com> <1193156487.26974.39.camel@localhost.localdomain>
In-Reply-To: <1193156487.26974.39.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 17:09:55.0405 (UTC) FILETIME=[887ABFD0:01C81597]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Jackson wrote:
> On Tue, 2007-10-23 at 09:18 -0700, Kok, Auke wrote:
>> Adam Jackson wrote:
>>> When the EEPROM gets corrupted, you can fix it with ethtool, but only if
>>> the module loads and creates a network device.  But, without this option,
>>> if the EEPROM is corrupted, the driver will not create a network device.
>>>
>>> Signed-off-by: Adam Jackson <ajax@redhat.com>
>> NAK
>>
>> wrong list, not sent to me, and while for e100 I was OK with this patch, for e1000
>> it really does not make sense to 'just allow' a bad checksum - if your eeprom is
>> randomly messed up then you cannot just fix it like this anyway.
> 
> That's strange, I managed to recover an otherwise horked e1000 with it.
> What should I have done instead?


Dump the eeprom and send us a copy, plus any and all information to the card,
system etc.. I realize that you need the patch to actually create it but the
danger is that people will start using it *without* troubleshooting the real
issue. In various systems the eeprom checksum failure is actually due to a
misconfigured powersavings feature and the checksum is really not bad at all, but
the card just reports random values.

In any case, this patch should not be merged. We often send it around to users to
debug their issue in case it involves eeproms, but merging it will just conceal
the real issue and all of a sudden a flood of people stop reporting *real* issues
to us.

for e100 the case is completely different: there are many boarded e100 chips out
there mostly on embedded devices where the embedded manufacturer just forgot to
even program the eeprom, and the device really does not care that much at all.

Cheers,

Auke


Auke
