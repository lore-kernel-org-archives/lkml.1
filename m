Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbXE0NI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbXE0NI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 09:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXE0NIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 09:08:01 -0400
Received: from smtpout.mac.com ([17.250.248.178]:58760 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXE0NH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 09:07:59 -0400
In-Reply-To: <46594282.8010307@iinet.net.au>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <46594282.8010307@iinet.net.au>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <35FC8780-88BD-4FF0-AF0D-17A9A0E1BF1F@mac.com>
Cc: Andreas Gruenbacher <agruen@suse.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sun, 27 May 2007 09:07:35 -0400
To: Cliffe <cliffe@iinet.net.au>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CC trimmed to remove a few poor overloaded inboxes from this tangent.

On May 27, 2007, at 04:34:10, Cliffe wrote:
> Kyle wrote:
>> On the other hand, if you actually want to protect the _data_,  
>> then tagging the _name_ is flawed; tag the *DATA* instead.
>
> Would it make sense to label the data (resource) with a list of  
> paths (names) that can be used to access it?
>
> Therefore the data would be protected against being accessed via  
> alternative arbitrary names. This may be a simple label to maintain  
> and (possibly to) enforce, allowing path based confinement to  
> protect a resource. This may allow for the benefits of pathname  
> based confinement while avoiding some of its problems.

The primary problem with that is that "mv somefile otherfile" must  
change the labels, which means that every process that issues a rename 
() syscall needs to have special handling of labels.  The other  
problem is that many of the features and capabilities of SELinux get  
left by the wayside.  On an SELinux system 90% of the programs don't  
need to be modified to understand labels, since the policy can define  
automatic label transitions.  SELinux also allows you to have  
conditional label privileges based on boolean variables, something  
that cannot be done if the privileges themselves are stored in the  
filesystem.  Finally, such an approach does not allow you to  
differentiate between programs.

Cheers,
Kyle Moffett

