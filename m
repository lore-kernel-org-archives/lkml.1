Return-Path: <linux-kernel-owner+w=401wt.eu-S966217AbXDGSRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966217AbXDGSRK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966236AbXDGSRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:17:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41667 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966217AbXDGSRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:17:09 -0400
Message-ID: <4617E032.4080408@us.ibm.com>
Date: Sat, 07 Apr 2007 13:17:22 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-cifs-client@lists.samba.org
Subject: Re: Samba, inotify on a Windows share
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's what I try to do. I want to monitor from a Linux Gentoo 
> machine with inotify enabled on a directory for new files hosted by a 
> windows share(Windows server, not Samba).


Samba now uses inotify if available on the server side to support the 
Directory Change Notification requested by certain cifs client (Windows 
explorer on most Windows clients e.g.) but the Linux CIFS client does 
not have a complete implementation of the mapping between the fcntl 
dnotify (the old way to do the same thing on Linux) and the cifs 
transact change notify request on the wire.  It would not be too hard to 
finish up if anyone is looking for a small project.   support for 
inotify on the client (mapping to the cifs transact change notify on the 
wire) would be a little harder because Linux's inotify is a broader API 
than the older fcntl but it could be done for some common cases.
