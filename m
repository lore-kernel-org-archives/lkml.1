Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXEZSRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXEZSRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXEZSQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:16:57 -0400
Received: from smtpout.mac.com ([17.250.248.177]:63902 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXEZSQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:16:55 -0400
In-Reply-To: <200705262344.HGG92040.QtGFWFTOJMHOEFV@I-love.SAKURA.ne.jp>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <200705261346.20712.agruen@suse.de> <200705262109.JJB99189.TFHFGQEOtVOMWJF@I-love.SAKURA.ne.jp> <200705261541.09891.agruen@suse.de> <200705262344.HGG92040.QtGFWFTOJMHOEFV@I-love.SAKURA.ne.jp>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5630E353-1556-4A0F-8618-D885B5BC1842@mac.com>
Cc: agruen@suse.de, casey@schaufler-ca.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 14:16:26 -0400
To: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 26, 2007, at 10:44:46, Tetsuo Handa wrote:
> Andreas Gruenbacher wrote:
>> Tetsuo Handa wrote:
>>> Therefore, TOMOYO Linux checks the combination of filename and  
>>> argv[0] passed to execve().
>>
>> So you are indeed trying to control the value of argv[0]? Well,  
>> good luck with that, but it's totally insane. You are guaranteed  
>> to break some applications.
>
> TOMOYO Linux ristricts argv[0] using allow_argv0 syntax.   
> "allow_argv0 /bin/bash -bash" to allow passing "/bin/bash" to  
> filename and "-bash" to argv[0].  "allow_argv0 /bin/gzip gunzip" to  
> allow passing "/bin/gzip" to filename and "gunzip" to argv[0].   
> "allow_argv0 /sbin/busybox cat" to allow passing "/sbin/busybox" to  
> filename and "cat" to argv[0].  No need to use allow_argv0 syntax  
> if the basename of filename and basename of argv[0] are the same  
> (i.e. "allow_argv0 /bin/bash bash" is not required).  TOMOYO Linux  
> doesn't unconditionally forbid passing different values for  
> filename and argv[0].  TOMOYO Linux allows passing different values  
> for filename and argv[0] only if it is allowed by allow_argv0 syntax.
>
> Could you please explain me why this approach breaks applications?

One of my servers runs 3 different instances of the "kadmind"  
Kerberos daemon, one for each realm which I need to be able to modify/ 
change-passwords/etc.  In order to differentiate and stop/restart the  
appropriate daemon, I have a simple starter script which runs each  
kadmind process with a unique name derived from the realm (EG:  
"kadmind(EXAMPLE.COM)", "kadmind(OTHER.EXAMPLE.COM)").  Since this is  
a Kerberos server I use a very strict SELinux-based policy, yet my  
management tools need to be able to easily add and remove realms in a  
secure fashion.  It sounds like TOMOYO Linux would not be able to  
handle this situation at all;  I would either have to completely turn  
off that security "feature" and lose most of the functionality of  
TOMOYO Linux, or hard-code the list of realms into the policy file  
and have to completely reload policy every time I need to add/remove  
realms (big gaping security hole).

Cheers,
Kyle Moffett



