Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbXIJV25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbXIJV25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 17:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXIJV2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 17:28:50 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43431 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbXIJV2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 17:28:50 -0400
Message-ID: <46E5B6FA.7000902@nortel.com>
Date: Mon, 10 Sep 2007 15:28:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RFC: possible bug in load_elf_binary
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Sep 2007 21:28:29.0505 (UTC) FILETIME=[87D74B10:01C7F3F1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

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
