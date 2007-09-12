Return-Path: <linux-kernel-owner+w=401wt.eu-S970115AbXILSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970115AbXILSgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXILSgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:36:12 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:54028 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXILSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:36:11 -0400
Message-ID: <46E83191.5070208@nortel.com>
Date: Wed, 12 Sep 2007 12:36:01 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>,
       James Bottomley <James.Bottomley@steeleye.com>, bapper@piratehaven.org,
       aaw@google.com
Subject: RFC: bug in load_elf_binary?
References: <46E5B6FA.7000902@nortel.com>
In-Reply-To: <46E5B6FA.7000902@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2007 18:36:04.0698 (UTC) FILETIME=[C6AE83A0:01C7F56B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


No responses in a couple days so I'm resending.  I've CC'd a few people 
who've touched binfmt_elf.c recently.


We've got an unusual elf binary and we seem to be running into a bug in 
the elf loader.  I'm not an elf expert, so my apologies if I get the 
terminology wrong.

The elf spec says that PT_LOAD segments must be ordered by vaddr.  We 
want to have a segment at a relatively low fixed vaddr.  The exact 
address is not important, except that it's lower than the standard elf 
headers and so it must be the first segment in the elf file.

However, this segment also has no size in the file...it's basically all 
statically allocated at runtime.

In the kernel elf loader, the p_vaddr and p_offset of the first segment 
are used to determine the load_addr for use with the rest of the 
segments.  In the case of this elf file, the first segment does not 
actually have a valid p_offset.

Anyone have any suggestions on how to deal with this?  One crude hack we 
considered was to simply not set the load_addr if the first segment 
doesn't have a valid p_offset, but that doesn't solve the general case.

Thanks,

Chris
