Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXE0CLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXE0CLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXE0CLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:11:08 -0400
Received: from smtpout.mac.com ([17.250.248.177]:55744 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbXE0CLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:11:06 -0400
In-Reply-To: <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
Cc: James Morris <jmorris@namei.org>, casey@schaufler-ca.com,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 22:10:34 -0400
To: Toshiharu Harada <haradats@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 26, 2007, at 19:08:56, Toshiharu Harada wrote:
> 2007/5/27, James Morris <jmorris@namei.org>:
>> On Sat, 26 May 2007, Kyle Moffett wrote:
>>> AppArmor).  On the other hand, if you actually want to protect  
>>> the _data_, then tagging the _name_ is flawed; tag the *DATA*  
>>> instead.
>>
>> Bingo.
>>
>> (This is how traditional Unix DAC has always functioned, and is  
>> what SELinux does: object labeling).
>
> Object labeling (or labeled security) looks simple and straight  
> forward way, but it's not.
>
> (1) Object labeling has a assumption that labels are always  
> properly defined and maintained. This can not be easily achieved.

That's a circular argument, and a fairly trivial one at that.  If you  
can't properly manage your labels, then how do you expect any  
security at all?  If you can't manage your "labels", then pathname- 
based security won't work either.  This is analogous to saying  
"Pathname-based security has an assumption that path-permissions are  
always properly defined and maintained", which is equally obvious.   
If you can't achieve the first with reasonable security, then you  
probably can't achieve the second either.  Also, if you can't manage  
correct object labeling then I'm very interested in how you are  
maintaining secure Linux systems without standard DAC.

> (2) Also, assigning a label is something like inventing and  
> assigning a *new* name (label name) to objects which can cause flaws.

I don't understand how assigning new attributes to objects "can cause  
flaws", nor what flaws those might be; could you elaborate further?   
In particular, I don't see how this is really all that more  
complicated than defining additional access control in  
apache .htaccess files.  The principle is the same:  by stacking  
multiple independent security-verification mechanisms (Classical UNIX  
DAC and Apache permissions) you can increase security, albeit at an  
increased management cost.  You might also note that ".htaccess"  
files are yet another form of successful "label-based" security; the  
security context for a directory depends on the .htaccess "label"  
file found within.  The *exact* same principles apply to SELinux: you  
add additional attributes backed by a simple and powerful state- 
machine.  The cross-checks are lower-level than those from .htaccess  
files, but the principles are the same.

Cheers,
Kyle Moffett



