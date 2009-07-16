Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbZGPRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbZGPRXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbZGPRXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:23:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:45084 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbZGPRXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:23:45 -0400
Date: Thu, 16 Jul 2009 10:23:45 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: deterministic scsi order with async scan
In-Reply-To: <20090716115703.GQ24310@parisc-linux.org>
Message-ID: <alpine.DEB.1.10.0907161022540.9159@asgard>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <20090716115703.GQ24310@parisc-linux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Matthew Wilcox wrote:

> On Wed, Jul 15, 2009 at 06:09:22PM -0700, david@lang.hm wrote:
>> is there any way to get deterministic device ordering with scsi async
>> scanning?
>>
>> currently (2.6.30) it seems that the various scsi busses are loaded in
>> the order that they are detected, which can vary from boot to boot
>> depending on how long it takes for the card to initialize.
>
> I think you're confused.  The async scsi scanning was designed to _not_
> move devices around randomly.  There are other asynchronous schemes in
> the kernel, some of which were not designed with the same care.
>
> The SCSI async scan can't do much about it if the busses are detected
> in a different order.
>
>> would it be possible to detect the cards/drives, but not register them
>> until all the detection is complete so that they can be registered in a
>> deterministic order?
>
> That's exactly how the scsi async scanning works.

hmm, in that case how can I troubleshoot why this system is detecting the 
two different PCI-E cards in different orders on different boots.

David Lang

>> having two drives on two different controllers swap positions from boot
>> to boot makes it very painful. yes I can make an initrd that fixes this
>> up in user space by examining each drive and creating links to re-order
>> them, but this is a lot of work to fix randomization that can be
>> prevented in the first place.
>>
>> David Lang
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
