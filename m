Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbXJQNJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbXJQNJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXJQNJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:09:28 -0400
Received: from rtr.ca ([76.10.145.34]:2237 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbXJQNJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:09:26 -0400
Message-ID: <47160984.7030308@rtr.ca>
Date: Wed, 17 Oct 2007 09:09:24 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/4] Fix PCIe hotplug for non-ACPI ExpressCard
 slots (version 2)
References: <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca> <20071017032907.GA16728@parisc-linux.org>
In-Reply-To: <20071017032907.GA16728@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 16, 2007 at 09:54:08PM -0400, Mark Lord wrote:
>> -	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
>> +	/* Check if slot is occupied */
>> +	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
>>  	if ((POWER_CTRL(ctrl->ctrlcap)) && !value) {
>> -		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
>> +		/* Power off slot if not occupied*/
>> +		rc = t_slot->hpc_ops->power_off_slot(t_slot);
> 
> I'd argue these comments fall under "stating the bleedin' obvious", but
> that's Kristen's call.

Hey, they're original to the file.  I'm just keeping checkpatch.pl happy here.
Ditto for everything else you commented on.

>>  	case INT_PRESENCE_OFF:
>>  		if (!HP_SUPR_RM(ctrl->ctrlcap))
>>  			break;
>> -		dbg("Surprise Removal\n");
>> +		dbg("Surprise Event\n");
>>  		update_slot_info(p_slot);
>>  		handle_surprise_event(p_slot);
>>  		break;
> 
> That doesn't seem like an obviously correct change to me.  Can you
> explain?

Yeah.  You clipped the top line:  case INT_PRESENCE_ON:
So that code can be run for both hot plug and hot remove operations.

..
>> -	temp_word = (temp_word & ~intr_enable) | intr_enable; 
>> +	temp_word = (temp_word & ~intr_enable) | intr_enable;
> 
> *boggle*

Dig out your text editor, and notice the excess whitespace at the end of the line,
along with similar stuff on most other lines in this patch.
This is all just stuff that checkpatch.pl complains about when
the later patches are applied, so patch 01_... serves to reduce
the noise level from checkpatch.pl for the *real* patches which follow.

-ml
