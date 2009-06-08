Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZFHLGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZFHLGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZFHLGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:06:19 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54339 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZFHLGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c6aVt/JGKtDhNYbBTAGWMflNGoZ1yPdNH4U/St0jHxLtZCYwYuSjEgyPIYfE68zICh
         bPCrXglaoFICtJUum+/f9AF+jxYVWVMkYR6Wj6SzZc0Pfzy/EVxee8KKlfekZ1hd66J4
         9GB7mZEm2PRx4eB0T1Qp7lft+w224A6N62b5E=
MIME-Version: 1.0
In-Reply-To: <4A2CEC5B.3000001@msgid.tls.msk.ru>
References: <4A2CE6AC.4030403@msgid.tls.msk.ru>
	 <4A2CEC5B.3000001@msgid.tls.msk.ru>
Date: Mon, 8 Jun 2009 13:06:19 +0200
Message-ID: <19f34abd0906080406xd5ed8cwbd4193f2bbf97699@mail.gmail.com>
Subject: Re: 2.6.30-rc8 does not boot
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/8 Michael Tokarev <mjt@tls.msk.ru>:
> Michael Tokarev wrote:
>>
>> Hello.
>>
>> I just gave 2.6.30-rc a try, taken from Linus git, tag v2.6.29-rc8.
>> And this one does not want to boot on my test machine which is an
>> AMD X2-64 with AMD780G chipset.  Neither 64 nor 32bit kernel boots.
>> I even tried in kvm virtual machine, -- same effect.  It freezes right
>> after displaying "Verifying BIOS data successful" message -- nothing
>> more is on the screen.
[...]
> PANIC: early exception 0e rip: 10:ffffffff802c9abd error 0 cr2 0

That seems to be a NULL dereference (0e = page fault, cr2 0 =
dereferenced address).

Try:
$ addr2line -e vmlinux -i ffffffff802c9abd

This should print the name of the function that crashed. If you enable
CONFIG_DEBUG_INFO you can get the exact line number info too (but
remember to replace the ffffffff802c9abd with the new value if you
recompile and run it again).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
