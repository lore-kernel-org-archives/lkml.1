Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZCDPES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZCDPES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZCDPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:04:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39097 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbZCDPEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:04:05 -0500
Message-ID: <49AE9850.9020103@redhat.com>
Date: Wed, 04 Mar 2009 10:03:44 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] fix DMI for EFI
References: <49A9F597.4010601@redhat.com> <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com> <49ADEDA3.1030406@redhat.com> <20090304110022.GB18165@elte.hu>
In-Reply-To: <20090304110022.GB18165@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>Hm, could we ever find ourselves in the positition of having to 
>access the DMI strings table in the EFI init code, to implement 
>a quirk? I think that's quite plausible.

>OTOH, with some DMI quirks in EFI tables it's a bit of a chicken 
>and egg problem. Can DMI strings ever be outside of EFI tables 
>on EFI systems?

>	Ingo

Right now it is EFI that loads the dmi tables (and all other tables such 
as ACPI), so it is a chicken and the egg. I think that if dmi is ever 
needed by EFI, the dmi scan will have to be moved inside efi_init. We 
could move the dmi scan into efi_init and do the dmi scan the moment we 
have the dmi table. Thats really the soonest point we could scan on EFI 
systems. Im OK with moving dmi to efi_init if you prefer.

Brian






