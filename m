Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbXKQRZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbXKQRZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXKQRY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:24:59 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:56343 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXKQRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:24:58 -0500
Message-ID: <473F2464.3020905@abinetworks.biz>
Date: Sat, 17 Nov 2007 18:27:00 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Gianluca Alberici <gianluca@abinetworks.biz>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       markus reichelt <ml@mareichelt.de>, linux-kernel@vger.kernel.org
Subject: Re: NFS Bug in 2.6.23 ?
References: <473D6B5C.4090701@abinetworks.biz>	 <20071116121148.GI4290@tatooine.rebelbase.local> <1195222863.7653.18.camel@heimdal.trondhjem.org> <473EEEC7.1070300@abinetworks.biz>
In-Reply-To: <473EEEC7.1070300@abinetworks.biz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have found out something new about the cfs problem:

1) on a 2.6.20, working good:

after starting cfs, nothing cattach'd:

zeus:~# cat /proc/fs/nfsfs/volumes
NV SERVER   PORT DEV     FSID
v2 7f000001  be9 0:14    0:0

after cattaching (and at least once listing the directory, if not 
everything remains as above):

zeus:~# cat /proc/fs/nfsfs/volumes
NV SERVER   PORT DEV     FSID
v2 7f000001  be9 0:14    0:0
v2 7f000001  be9 0:15    1:0

from now everything is OK forever....

2) On 2.6.23  at cfsd restart

mars:~# cat /proc/fs/nfsfs/volumes
NV SERVER   PORT DEV     FSID
v2 7f000001  be9 0:14    0:0

after cattaching i get

mars:~# cat /proc/fs/nfsfs/volumes
NV SERVER   PORT DEV     FSID
v2 7f000001  be9 0:14    1:0
v2 7f000001  be9 0:15    1:0

The first FSID has chnaged and is 1:0 as the second while on 2.6.20 this 
doesnt happens.
I know nothing about NFS internals but isnt strange to have the same 
FSID on 2 volumes ?

BTW, the 2 machines have the same disk image. No diffs but the kernel.

Maybe this means nothing, if so sorry for the noise.

Gianluca




