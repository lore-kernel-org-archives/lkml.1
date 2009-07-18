Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZGRS1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZGRS1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZGRS1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:27:39 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58052 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZGRS1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xEKa3ATD1UWEjUF2UGdQKciElcqnZyetlJgOZFmo/6AbTYlkEVeVoQFBni1Ugfv6Qn
         GIumF6wzSU4OLmEmXbhFOQ+vHwVLfsPUNcwqlKG+Ft0kQyHiH/SBQMIgLFcKpHSEvy8Z
         mVzuk/OSAju/zytyqa/QaxrOc7dMdQQZwZ5Fs=
Message-ID: <4A621416.2060609@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 19:27:34 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: "floppy: fix hibernation" causes error on resume from ram
References: <4A620F3E.8080900@tuffmail.co.uk> <200907182019.57909.linux@rainbow-software.org>
In-Reply-To: <200907182019.57909.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> On Saturday 18 July 2009 20:06:54 Alan Jenkins wrote:
>   
>> Thanks for the hibernation fix!  Until recently I thought my floppy was
>> just dead.  Unfortunately, the fix seems to cause me errors on resume
>> from suspend to ram.  The floppy works fine afterwards, it just spams
>> the log.
>>
>> On 2.6.30 there were no errors, and the floppy survived suspend-to-ram.
>> So I guess the quick fix would be to only do the fix-up on resume from
>> hibernation, and not suspend-to-ram.
>>     
>
> My machine has no suspend-to-RAM so I haven't tested it.
>
> That would be probably the correct fix. But how to do it? AFAIK, there's only 
> one suspend() and one resume() for everything. And that looks very wrong as 
> resume-from-hibernation is fundamentally different from resume-from-RAM.
>   

Ok.  Looking at drivers/base/platform.c, we want "restore()".  I guess I
can do the patch myself :-).

Thanks
Alan
