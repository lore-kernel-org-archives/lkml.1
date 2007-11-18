Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbXKRSpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbXKRSpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 13:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXKRSp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 13:45:27 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:34497 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXKRSp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 13:45:26 -0500
Message-ID: <474087F6.9030305@abinetworks.biz>
Date: Sun, 18 Nov 2007 19:44:06 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: NFS Bug in 2.6.23 ? SOLUTION ?
References: <473D6B5C.4090701@abinetworks.biz>	 <20071116121148.GI4290@tatooine.rebelbase.local> <1195222863.7653.18.camel@heimdal.trondhjem.org> <473EEEC7.1070300@abinetworks.biz> <473F2464.3020905@abinetworks.biz>
In-Reply-To: <473F2464.3020905@abinetworks.biz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond,

The problem is in nfs_mountpoint_timeout. After this time 
dentry_delete(/,4) removes the mountpoint, then it is very difficult to 
automount (at least with CFSD), one has got to try 2 or three times 
cd'ing into the mount point. Applications wont ever had the chance to 
autoremount (ENOTDIR).

I have some questions:

- nfs_mountpoint_timeout seems to be set in sysctl.c even if nfsv4 is 
not. Is this correct ? I've read somewhere that it was introduced for v4.
- Why this sysctl is not registered in my 2.6.20 kernel where it should 
be registered ?
- Why this parameter has not a 'disabled' value (i mean kind of -1) ?

Thanks,

Gianluca
