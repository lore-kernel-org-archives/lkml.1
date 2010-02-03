Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0BCBmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:42:18 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:45043 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab0BCBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:42:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XCLViNHqSG4Yqk57LA2r+uhsUui/8BwPzBON4kreRSdgPykWH9mGGcW4c67WFCmU3U
         BzVoTJqSyFHfOpwfJL81B/jbUjmP87SMEW9noSmAZB7dxyGGungxGU7kUoSbRe0JnVUD
         20oiJDJIZPWAjEM+OYA6DPfOPLK8181rKcqOc=
Message-ID: <4B68D4CA.2010803@gmail.com>
Date: Tue, 02 Feb 2010 17:43:38 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de>
In-Reply-To: <4B67CCEC.2030103@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. finally finished with the bisect:

reverting this gets things going on 2.6.33-rc5

789d03f584484af85dbdc64935270c8e45f36ef7 is the first bad commit
commit 789d03f584484af85dbdc64935270c8e45f36ef7
Author: Jan Beulich <JBeulich@novell.com>
Date:   Tue Jun 30 11:52:23 2009 +0100

     x86: Fix fixmap ordering

     The merge of the 32- and 64-bit fixmap headers made a latent
     bug on x86-64 a real one: with the right config settings
     it is possible for FIX_OHCI1394_BASE to overlap the FIX_BTMAP_*
     range.

     Signed-off-by: Jan Beulich <jbeulich@novell.com>
     Cc: <stable@kernel.org> # for 2.6.30.x
     LKML-Reference: <4A4A0A8702000078000082E8@vpn.id2.novell.com>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>

The only thing I can think of at this point
is maybe the CFLAGS I used to build this system.
(as for the x86_32 working and x86_64 failing not sure);

I'm curious to see if anybody else is hitting this?

Justin P. Mattock
