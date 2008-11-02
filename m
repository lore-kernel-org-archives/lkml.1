Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYKBNXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYKBNXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYKBNXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:23:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6615 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYKBNXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=aDxXw//0de/q/wJkDrOBBS62PQjGR11hWyhItgZmJ/vUjqeeSFIvSnZzIrIUQHM9TV
         A45oUaJfPe8/U8HH0PqzHo7Bm+b84HcS/f3yc/QOvSl6ghNAfEd7L2j87lEcXdEu4aTq
         CyRQ1abD0Qibl8Ht8IwOHvYzMpVnj/gSOVFq4=
Message-ID: <490DAA33.7010905@tuffmail.co.uk>
Date: Sun, 02 Nov 2008 13:25:07 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org>
In-Reply-To: <20081102130655.GA12766@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sun, Nov 02, 2008 at 11:17:34AM +0000, Alan Jenkins wrote:
>
>   
>> Did you have any thoughts on the hibernation case? It's possible for the 
>> rfkill state to change while hibernated. You can boot into a different 
>> OS, or change it in the BIOS setup screen. At present the rfkill core 
>> overrides the change on resume.
>>     
>
> There are two choices. We can either set the rfkill to the hardware 
> state, or we can set the hardware state to the rfkill state. I think 
> both are valid choices and I'm happy to implement either of them in the 
> resume path. However, as you point out, right now it's possible for the 
> user to change the hardware state in the BIOS and cause the two to get 
> out of sync. That's certainly not ideal.
>   

No, the current rfkill core forces the device to restore the state on 
resume.  So it can't be of sync after resume.  And there's no way for 
the platform driver to affect this behaviour, aside from illegally 
generating input events.

If we want resume from hibernation to preserve the hardware state 
instead of overriding it, the rfkill API needs changing.  I'm not sure 
how that can be justified, given how obscure it is as a use-case, and 
the damage it would do to an API which already, uh, seems to be 
frequently misunderstood.

Regards
Alan
