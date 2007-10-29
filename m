Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbXJ2Piz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbXJ2Piz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXJ2Pir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:38:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:28995 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752352AbXJ2Pir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:38:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,343,1188802800"; 
   d="scan'208";a="362588249"
In-Reply-To: <d120d5000710290833i5ed524d6ne95fc1ef34834566@mail.gmail.com>
References: <4725F2DF.1060500@garzik.org> <20071029152050.GA23411@bigserver.hohndel.org> <d120d5000710290833i5ed524d6ne95fc1ef34834566@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3CE5A712-C0BE-45EE-9171-C3B54F789483@linux.intel.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Jiri Kosina" <jikos@jikos.cz>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Hohndel, Dirk" <hohndel@linux.intel.com>
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Date: Mon, 29 Oct 2007 08:38:08 -0700
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29, 2007, at 8:33 AM, Dmitry Torokhov wrote:

> On 10/29/07, Dirk Hohndel <hohndel@linux.intel.com> wrote:
>>
>> Actually, the more I look at the code that bails when it runs out  
>> of memory,
>> the more I wonder about that.
>>
>>        hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
>>        input_dev = input_allocate_device();
>>        if (!hidinput || !input_dev) {
>>                kfree(hidinput);
>>                input_free_device(input_dev);
>>
>> This either passes a NULL pointer to kfree or to  
>> input_free_device. That's
>> not nice.
>>
>
> No, that's allright. input_free_device() takes after kfree() so that
> it safe to call it with NULL pointer.

Ahh - should have checked that.

Will the rest of the patch work with the call to hidinput_disconnect?  
If yes then
I'll send a cleaned up version that removes the unnecessary checks in  
the case here...

/D	
