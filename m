Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZFFJjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZFFJjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZFFJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:39:48 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49509 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZFFJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PnbgjqH2nroq4Pm++/+g+SRkAbA9RtEpWtxUQ/dOMkRMkQlVyRDBdh+b5rfS/2DZ49
         IDdVbCv04S21K+nERQlYhOKWcHvS5m5FnPsZuIaoz2dR1eouPTz/Kr9nCUppQChKOg+C
         3fXw8Bwd3v0kq6hMfLYUqCzZJk8Rdn/syNstk=
Message-ID: <4A2A3961.3030504@gmail.com>
Date: Sat, 06 Jun 2009 11:39:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.2 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jeff Mitchell <jeffrey.mitchell@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Panic early in boot
References: <9599edfc0906051439s7e006edcrdb68ccde60d51815@mail.gmail.com>
In-Reply-To: <9599edfc0906051439s7e006edcrdb68ccde60d51815@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2009 11:39 PM, Jeff Mitchell wrote:
> Output is pasted below.  It's hand-typed from a screenshot, so
> hopefully I didn't mistype anything.  

Don't worry to append a link to the screenshot next time ;).

> console [earlyvga0] enabled
> DMI present.
> PANIC: early exception 0e rip 10:ffffffff80866edc error 0 cr2 ffffffffeff44003d
> Pid: 0, comm: swapper Not tainted 2.6.29-gentoo-r5 #2
> Call Trace:
> early_idt_handler+0x5e/0x71
> dmi_string_nosave+0x34/0x80
> dmi_string_nosave+0x67/0x80
> dmi_string+0xa/0x6e
> dmi_save_ident+0x1b/0x2a
> dmi_decode+0x72/0x492
> _spin_unlock_irqrestore+0x14/0x17
> __early_set_fixmap+0xa0/0xa7
> dmi_table+0x4e/0x78
> dmi_scan_machine+0x132/0x19f
> setup_arch+0x34d/0x636
> early_idt_handler+0x0/0x71
> start_kernel+0x86/0x35e
> x86_64_start_kernel+0xed/0xf6
> RIP dmi_string_nosave+0x34/0x80

Looks like dmi_string_nosave gets a mess. It tries to dereference
0xffffffffeff44003d. Could you investigate to which save_indent in
dmi_decode does the dmi_decode+0x72 correspond to?

Is this vanilla, i.e. what does -gentoo-r5 mean?

And also append a dmidecode output from a working kernel.
