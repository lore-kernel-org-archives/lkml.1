Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYCHKR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYCHKR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 05:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYCHKRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 05:17:48 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:39740 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYCHKRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 05:17:47 -0500
Message-ID: <47D26836.4090403@abinetworks.biz>
Date: Sat, 08 Mar 2008 11:19:34 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Process segfault causing sys resource block
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I want to submit this case which in my understanding is quite abnormal. 
I have found on a production server (2.6.20)
three segfaulted apache child  that are marked as 'D'efunct.
Stopping apache caused init to adopt them. But they dont respond (i 
think because being segfaulted they're probably not in a good mood)
and they (one of them) keep locked:

- TCP port 80 (Got open/freezed socket)
- The nfs mount over which they read files

Result: i have three 'defunct' processes that are basically locking main 
system resources. Cant restart apache, cant restart NFS.
Only solution (for me): rebooting (and thats what i did).

Is there any other way to wipe these processes and/or freeing sys 
resources without rebooting ?
If not, wouldnt it be a good thing to avoid userspace crashes like this 
to cause deadlocks/DOS ?

Thanks for any help/opinion,

Gianluca


