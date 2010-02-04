Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0BDJQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:16:20 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:58700 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab0BDJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QTT2lQbSk8+QtYq1M8xQs62OVtSJUJnBr98yLadyBw0SKRtDjRLczlUoehBT3BdHD8
         r7H28f2GR3XZiXXB69dcU2y9sxlW/mrJucjhYkQV76Q8qKaDcJsGTPtbtBev+bA4KOm8
         zZi1RBymka44Mlyk024TE4hdhqOQQReHHGsyU=
Message-ID: <4B6A90BB.7090405@gmail.com>
Date: Thu, 04 Feb 2010 01:17:47 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Dan Carpenter <error27@gmail.com>,
       bernhard.kaindl@gmx.net, Thomas Gleixner <tglx@linutronix.de>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Rafael Wysocki <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiderman@xmission.com, hpa@zytor.com
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug		 #14487]
 PANIC: early exception 08 rip 246:10 error		 ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de> <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com> <4B6A0123.3010607@gmail.com> <4B6A9960020000780002DA6B@vpn.id2.novell.com> <4B6A8DA9.4090804@gmail.com> <4B6A9D4C020000780002DA99@vpn.id2.novell.com>
In-Reply-To: <4B6A9D4C020000780002DA99@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/10 01:11, Jan Beulich wrote:
>>>> "Justin P. Mattock"<justinmattock@gmail.com>  04.02.10 10:04>>>
>> a quick google on this showed somewhere
>> at bootmem.c any ideas on this or where
>> this might be caused besides fixmap?
>> (or is fixmap the main location?);
>
> __native_set_fixmap() ->  set_pte_vaddr() ->  set_pte_vaddr_pud() ->
> fill_pte() ->  spp_getpage() ->  alloc_bootmem_pages() ->  panic().
>
> Jan
>
>

so something is using __native_set_fixmap
that's hitting some memory address then
set_fixmap_nocache(ohci1394_dma=early)
fires off hitting the same?

Justin P. Mattock
