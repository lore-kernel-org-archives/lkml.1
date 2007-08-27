Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbXH0SdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbXH0SdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbXH0Sc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:32:58 -0400
Received: from mail.reagi.com ([195.60.188.80]:52548 "EHLO mail.reagi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbXH0Sc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:32:57 -0400
Message-ID: <46D318D3.9020101@oxeva.fr>
Date: Mon, 27 Aug 2007 20:32:51 +0200
From: Gabriel Barazer <gabriel@oxeva.fr>
Organization: OXEVA
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: nfsv4@linux-nfs.org
CC: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       jkar8572@users.sourceforge.net
Subject: nfs4 filesystem mounted via the "bind" option reports wrong fstype
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A nfs4 filesystem, mounted elsewhere via the "bind" option (the usual 
way to do with nfsv4 and its pseudofs), reports wrong fstype "nfs" 
instead of "nfs4" filesystem.
An example is much easier to understand :
Server-side :
- /exports is the pseudo root filesystem (fsid=0 option in /etc/exports)
- /exports/data is a mountpoint for another filesystem (not the same 
device-id as /exports). This condition seems to be what triggers the bug
- /exports/data must be exported with the "nohide" option (again, the 
usual way to do se with nfsv4)

Client-side :
- mount server:/  on /imports
- mount "bind" /imports/data on /home/data
(this magically shows a second nfs mount in /proc/mounts)
And here is the bug : this second mount is of fstype "nfs" instead of 
"nfs4" although the options field contains "vers=4".

This is like a cosmetic bug, but this becomes a problem when some apps 
need to differentiate nfs and nfs4 fstype (e.g. linuxquota uses it to 
know how to handle the nfs source-path)

Gabriel
