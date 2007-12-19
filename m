Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXLSPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXLSPQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbXLSPQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:16:06 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:55424 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbXLSPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:16:05 -0500
Message-ID: <4769358B.2020406@abinetworks.biz>
Date: Wed, 19 Dec 2007 16:15:23 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23.9 NFS BUG ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for repeating but as far as i can see 2.6.23.11/12 got no changes 
into NFS.

I've run into this problem 2.6.23.9. The open syscall will return 
"Invalid argument" when O_TRUNC is set on existing files.

The same file can be opened for append or removed.

The evidence is for example:

mars:~# mount localhost:/opt/nfs/ /mnt/tmp
mars:~# echo "Hello" > /mnt/tmp/test-file
mars:~# echo "Hello" > /mnt/tmp/test-file
bash: /mnt/tmp/test-file: Invalid argument
mars:~# echo "Hello" > /mnt/tmp/test-file
bash: /mnt/tmp/test-file: Invalid argument
mars:~# echo "Hello" > /mnt/tmp/test-file
bash: /mnt/tmp/test-file: Invalid argument
mars:~# rm /mnt/tmp/test-file
mars:~# echo "Hello" > /mnt/tmp/test-file
mars:~# echo "Hello" > /mnt/tmp/test-file
bash: /mnt/tmp/test-file: Invalid argument


This is not present in 2.6.21.7.
This is really ugly...is this a bug or what ?

TIA

Gianluca
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
