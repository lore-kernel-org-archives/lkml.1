Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYJKTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYJKTbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYJKTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 15:31:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:52177 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYJKTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 15:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pGrwu7zcH1eo8r7L2A0wkKK7GHPsrkKAl9Gv+4sKgruIXXlCIkQVLfMm3ZqdFfRzAB
         CnsxbB41jWaoaIkqCIANmC0zT0sylIaTFcTiUk97dWhQ3syzSWLhH83bgo+6hewmeRD9
         05Bab8d6lHiNZf3KqduC5xL7arcQN9q4rBKs8=
Message-ID: <48F0FEFA.7050308@gmail.com>
Date: Sat, 11 Oct 2008 23:31:06 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <48F0ED3A.9010001@tuffmail.co.uk> <48F0F2C6.6030000@suse.de> <200810112130.57757.rjw@sisk.pl>
In-Reply-To: <200810112130.57757.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 11 of October 2008, Alexey Starikovskiy wrote:
>   
>> Alan Jenkins wrote:
>>     
>>> I think I found the problem.  The "input buffer empty" wait depends on
>>> "interrupt mode" to work properly, and we don't immediately enable the
>>> interrupt on resume.  The wait should have a polling fallback anyway, to
>>> be consistent with the other transaction waits.
>>>
>>> Alan
>>>       
>> Yep, I think something like attached patch may help:
>>     
>
> [Can you please append patches instead of or apart from attaching them?
> That would make it easier to comment them.]
>
>   
Ok.
> if (!wait_event_timeout(ec->wait, ec_check_ibf0(ec),
> -                               msecs_to_jiffies(ACPI_EC_DELAY))) {
> +                               msecs_to_jiffies(ACPI_EC_DELAY)) &&
> +           !ec_check_ibf0(ec)) {
>
> Shouldn't this go under the spinlock?  Surely it can race with the GPE handler.
>
>   
No, we discussed this before -- we are outside of the transaction, thus 
no GPE
activity could interfere with ec_check_ibf0.

Regards,
Alex.
