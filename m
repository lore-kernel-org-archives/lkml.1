Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYJMQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYJMQju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYJMQjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:39:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36382 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYJMQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=h/ptA2Bi34Qghd5yT/gMmBt0Pm7dKx2e4HKViy45TS0pcpR1ms1Tj/1j3lVG7YfeJs
         mBOo0tuuLdBDVY+826vyn/ltMEyFee/4Y2Feu6AJgN+9++V+mrHBGrK6fM2Lpc6gs5ID
         sYN2BPnYe9epwcU9rWR0xJ6PsElophQnpbuEs=
Message-ID: <48F379C4.9070105@tuffmail.co.uk>
Date: Mon, 13 Oct 2008 17:39:32 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810112140.16662.rjw@sisk.pl> <48F100CA.2050600@suse.de> <200810112254.09094.rjw@sisk.pl> <48F1BFD0.7040004@tuffmail.co.uk> <48F24EAE.6020108@suse.de> <48F30554.1010607@tuffmail.co.uk>
In-Reply-To: <48F30554.1010607@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Alexis Starikovskiy wrote:
>   
>> Alan Jenkins wrote:
>>     
>>> Rafael J. Wysocki wrote:
>>>       
>>>> On Saturday, 11 of October 2008, Alexey Starikovskiy wrote:
>>>>  
>>>>         
>>>>> Rafael J. Wysocki wrote:
>>>>>    
>>>>>           
>>>>>>> No, we discussed this before -- we are outside of the
>>>>>>> transaction, thus no GPE
>>>>>>> activity could interfere with ec_check_ibf0.
>>>>>>>         
>>>>>>>               
>>>>>> Ok, this is in the process context and we don't really expect to
>>>>>> get an
>>>>>> interrupt at this point, but what happens if the EC generates an
>>>>>> event that's
>>>>>> not related to any transiaction.  Is that guaranteed to never happen?
>>>>>>       
>>>>>>             
>>>>> Interrupt handler in this case can't cause a change to status
>>>>> register, thus our read of it will not be affected by interrupt.
>>>>>     
>>>>>           
>>>> Ok, thanks.
>>>>
>>>> Alan, does the patch work for you?
>>>>
>>>> Rafael
>>>>   
>>>>         
>>> Yes.  Two reboot cycles, three suspend/resume cycles each, and no error
>>> message.
>>>
>>> I hope we have a better fix in mind though :-P.  The patch doesn't solve
>>> the unnecessary 500ms delay when this thing happens.
>>>       
>> Something like this?
>>
>> Regards,
>> Alex.
>>     
>
> You sent it as an attachment again :-).
>
> That should work, odd as it looks.  We don't need to worry about the GPE
> workaround because that's only active _inside_ the transaction.  I don't
> know what Zhao thinks is missing.
>
> Sorry I can't test right now.  I tried to install 3D support on my
> laptop for showing-off purposes, and somehow broke X.
>   
Drama over, I've now tested it.  No error messages, and the printk
timings show that it has stopped hanging for half a second.

Thanks
Alan
