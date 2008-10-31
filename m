Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYJaR2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYJaR2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYJaR1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:27:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:4406 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYJaR1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=bn8GW1wWIpIM0i3HXhvmQ5onD13J3WwwqvtL5HqpFhUOmymC8LKjtQCsVAIw1MWzsE
         L6GiXW0eOFUkUigUw0nkB5obhQgkKo1dnBWLS5+Rg1XyC3gk0W/z/LUS9dOtHwKMbDtb
         y5EcBOstL8kUfTmmVOZYp8v3TP37VpVgbg98w=
Message-ID: <490B4014.4040009@tuffmail.co.uk>
Date: Fri, 31 Oct 2008 17:27:48 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4 and 5
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org>
In-Reply-To: <20081031171126.GA17313@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Oct 31, 2008 at 05:09:09PM +0000, Alan Jenkins wrote:
>   
>> Did you miss a call to rfkill_force_state() on resume?
>>     
>
> Conceivably. I didn't test the hibernation case.
>
>   
>> Actually, normal boot doesn't preserve the setting either.  Your commit
>> changes the behaviour from the rfkill state being persistent across
>> reboot / power off (as a bios setting), to being always enabled on
>> boot.  It seems like a bad idea to me.
>>     
>
> This is the behaviour of the rfkill core.
>   
Documentation/rfkill.txt implied otherwise

    You should:
        - rfkill_allocate()
        - modify rfkill fields (flags, name)
        - modify state to the current hardware state (THIS IS THE ONLY TIME
          YOU CAN ACCESS state DIRECTLY)
        - rfkill_register()


Admittedly it doesn't say "and I promise not to gratuitously override
the state on registration".  Buti t seems weird though, to override the
value on registration instead of just setting a default in
rfkill_allocate().

Thanks
Alan
