Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXLNI0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXLNI0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXLNIZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:25:54 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:46834 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLNIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:25:53 -0500
Message-ID: <47623E44.6080504@abinetworks.biz>
Date: Fri, 14 Dec 2007 09:26:44 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23.9 NFS Invalid argument in fopen("something","w")
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've run into this problem on a 'localhost:' NFS mount on a 2.6.23.9: 
The fopen syscall will return "Invalid argument" trying to fopen in "w" 
mode an existing file. The same file can be opened for append or removed.

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



I've also noticed that the stat() syscall too returns bad values after 
the first readdir().

This is really ugly...anybody ?

TIA

Gianluca
