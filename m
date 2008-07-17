Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYGQQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYGQQpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYGQQpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:45:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:7772 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYGQQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=G+h2STZNN/dt38D2p0+uxThJTV+cZ1D2PmnYQ3zsPM7zrFwa3jvrJtYmt0TEQ1P1vS
         VXYwaIXlZZJeb/xAQAkIilfZ98RRpOGqjoJTflfoKJiAWp3QLd12E9ME5S6ggAg2kWUD
         jD9UcWmshbeWahCNPoHxbnTIzQKqR0m9XlU9M=
Message-ID: <487F7724.5080905@tuffmail.co.uk>
Date: Thu, 17 Jul 2008 17:45:24 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net>
In-Reply-To: <20080717162628.GB18457@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 17 Jul 2008, Alexey Starikovskiy wrote:
>   
>> Henrique de Moraes Holschuh wrote:
>>     
>>> On Thu, 17 Jul 2008, Alexey Starikovskiy wrote:
>>>       
>>>> Thanks for the patch, ACK.
>>>>         
>>> This one fixes a potentially bad problem, since we could ignore more than
>>> just hot key EC events by accident.  Maybe it should go to -stable?
>>>       
>> I vote for it
>>     
>
> Well, in that case, it would be best to tack a Cc: stable@kernel.org git
> footer to it right away, I think.
>
> IMHO, it would also be nice if the commit message made it more clear that
> the issue it solves can affect much more serious ACPI events than just hot
> key presses.
>
>   
Actually Alexey has another patch in bugzilla (#10919) which resolves
this issue in a better way.  It avoids polling altogether, which is good
because it means you get events immediately.  My laptop has backlight
adjustment hotkeys with hardware autorepeat, so it looks really jerky
with polling.

So I think I should withdraw my patch and leave this to Alexey.  I've
tested his fix on my laptop and it works fine.  It needs some more work
though - e.g. at the moment it spams the kernel log.

Thanks,
Alan
