Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXCTTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXCTTlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXCTTlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:41:37 -0400
Received: from Mail.MNSU.EDU ([134.29.1.12]:37606 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXCTTlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:41:36 -0400
Message-ID: <460038AA.4050506@mnsu.edu>
Date: Tue, 20 Mar 2007 14:40:26 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Multiple instances of program sharing same text segment ?
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A437@xmb-sjc-214.amer.cisco.com> <460023F1.8060102@goop.org>
In-Reply-To: <460023F1.8060102@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keep in mind that while the text of the program IS SHARED any 
configuration file that is then loaded into ram after the execution IS 
NOT SHARED.

BTW you can find out what is shared and not by taking a look at the proc 
files:

# ps auxwww | grep emacs | grep -v grep # -- find the pids
user       21529  0.2  0.3  16784  7560 pts/11   S+   14:27   0:00 
xemacs -nw
user       21549  0.2  0.3  16784  7548 pts/12   S+   14:27   0:00 
xemacs -nw

# cat /proc/21529/maps |grep xemacs | grep "r-xp" # -- find the mapped 
text executable
08048000-081f5000 r-xp 00000000 08:02 201672393  
/usr/bin/xemacs-21.4.19-nomule

# cat /proc/21549/maps |grep xemacs | grep "r-xp" # -- find the mapped 
text executable
08048000-081f5000 r-xp 00000000 08:02 201672393  
/usr/bin/xemacs-21.4.19-nomule

#ls -li /usr/bin/xemacs-21.4.19-nomule # -- confirm that 201672393 is 
the inode we're looking at.
201672393 -rwxr-xr-x 1 root root 1800764 2006-11-03 11:11 
/usr/bin/xemacs-21.4.19-nomule


Jeremy Fitzhardinge wrote:
> Ravinandan Arakali (rarakali) wrote:
>   
>> I note that do_exec calls do_mmap to map the executable file to memory.
>> But not sure what happens(w.r.t text sharing) when another instance of 
>> the program is invoked. BTW, this is 2.6.10.
>>     
>
> Yes, they will be shared.  As far as the rest of the kernel is
> concerned, an mmap is an mmap is an mmap, and the pages will be shared.
>
>     J
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
