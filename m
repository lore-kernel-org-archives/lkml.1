Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYJLJOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYJLJOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJLJN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:13:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:23392 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYJLJN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=aCgIWlhsEXPFPfcToJPoXqLgGTLdvsYtbSDsX4gVnFwlzfgvqhA/vvPw3eoOFGzgO5
         K9KdqaHSy0gfm12AH1MzvY+xYsaLpj43EvyPDtbc/wstYZwqlxA+oyyIFcyF9dPw7Iu+
         2MuueRCDDpzPIH2MhUQTwyR4I49DISfgOEh1Y=
Message-ID: <48F1BFD0.7040004@tuffmail.co.uk>
Date: Sun, 12 Oct 2008 10:13:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810112140.16662.rjw@sisk.pl> <48F100CA.2050600@suse.de> <200810112254.09094.rjw@sisk.pl>
In-Reply-To: <200810112254.09094.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 11 of October 2008, Alexey Starikovskiy wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>>> No, we discussed this before -- we are outside of the transaction, thus 
>>>> no GPE
>>>> activity could interfere with ec_check_ibf0.
>>>>         
>>> Ok, this is in the process context and we don't really expect to get an
>>> interrupt at this point, but what happens if the EC generates an event that's
>>> not related to any transiaction.  Is that guaranteed to never happen?
>>>       
>> Interrupt handler in this case can't cause a change to status register, thus our 
>> read of it will not be affected by interrupt.
>>     
>
> Ok, thanks.
>
> Alan, does the patch work for you?
>
> Rafael
>   

Yes.  Two reboot cycles, three suspend/resume cycles each, and no error
message.

I hope we have a better fix in mind though :-P.  The patch doesn't solve
the unnecessary 500ms delay when this thing happens.

Thanks
Alan
