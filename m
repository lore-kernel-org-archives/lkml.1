Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbXCWTLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbXCWTLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXCWTLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:11:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:53053 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbXCWTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nsg8MJFkkgvSx0oIlqBX6RdganK6wGsygZoik2NC0G1+188JEOpw+ez53RPbqwm89f5MA1VtIu3HRIxy5qUWXYrDsDHu9/z9ZXRalwZEzIsIev46uCH5CMhvlNhzQipbOkmdKH8cwqzwQEgO8oRpF2D43z1fpK1MD/C7ANtcyhU=
Message-ID: <88df6dda0703231211j509bc95eu5bf51d4c1e8fe24e@mail.gmail.com>
Date: Sat, 24 Mar 2007 00:41:00 +0530
From: "Ameya Mitragotri" <ameya.mitragotri@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: in-kernel data transfer between devices
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm trying to write data from device memory (VRAM in this case) to the
HDD with a kernel module. I want to avoid using the cache so i tried
to do a direct-io. Reading the code i figured it used 'get_user_pages'
and since VRAM is io mapped, those pages are marked VM_IO and hence
directio fails. Why is it taboo to write VM_IO pages using directio?
(is it because Device -> Device DMA is not possible?)

Now attempting to still do the same, im trying to copy VRAM data to a
buffer and still try and use the directio path. it will mean bypassing
the get_user_pages and may mean ugly hacking, but then i also read a
little about splice.  Wondering if splice is the way to go for a
device memory to disk in kernel data transfer?

I'm doing the above as an experiment. My actual goal is to transfer
data between devices in-kernel.

Thanks
Ameya
