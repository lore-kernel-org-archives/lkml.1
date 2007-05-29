Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXE2EBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXE2EBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 00:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbXE2EBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 00:01:10 -0400
Received: from smtpout.mac.com ([17.250.248.186]:53664 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXE2EBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 00:01:08 -0400
In-Reply-To: <20070528203838.GB5840@ucw.cz>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <12000.1180233422@turing-police.cc.vt.edu> <D9C70A8C-2307-4E5F-AE5F-2A347284B879@mac.com> <20070528203838.GB5840@ucw.cz>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FD1C999C-AF16-40AC-B0E1-87441E8FF078@mac.com>
Cc: Valdis.Kletnieks@vt.edu, Toshiharu Harada <haradats@gmail.com>,
       James Morris <jmorris@namei.org>, casey@schaufler-ca.com,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Mon, 28 May 2007 22:00:54 -0400
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 28, 2007, at 16:38:38, Pavel Machek wrote:
> Kyle Moffett wrote:
>> I am of the opinion that adding a  "name" parameter to the file/ 
>> directory create actions would be useful.  For example, with such  
>> support you could actually specify a  type-transition rule  
>> conditional on a specific name or substring:
>>
>> named_type_transition sshd_t tmp_t:sock_file prefix "ssh-"  
>> ssh_sock_t;
>>
>> Useful options for matching would be "prefix", "suffix", "substr  
>> (start,len)".  "regex" would be nice but is sorta computationally  
>> intensive and would be likely to cause more problems than it solves.
>
> Could someone implement this? AFAICT that prevents SELinux from  
> being superset of AppArmor... Doing this should be significantly  
> simpler than whole AA, and hopefully it will end up less ugly, too.

Really it would need to extend all action-match items with new  
"named_" equivalents, and most callbacks would need to be extended to  
pass in an object name, if available.  On the other hand, with such  
support implemented then the AppArmor policy compilation tools could  
be transformed into a simple SELinux policy generator.  I estimate  
that the number of new lines of kernel code for such a modified  
SELinux would be 100x less than the kernel code in AppArmor.

Cheers,
Kyle Moffett

