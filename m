Return-Path: <linux-kernel-owner+w=401wt.eu-S935259AbXHOSPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259AbXHOSPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbXHOSOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:14:49 -0400
Received: from smtpout.mac.com ([17.250.248.171]:57672 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbXHOSOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:14:48 -0400
In-Reply-To: <824590.88264.qm@web52508.mail.re2.yahoo.com>
References: <824590.88264.qm@web52508.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A699C8AE-6C16-46FA-9C55-EFA4FA1718ED@mac.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 14:14:27 -0400
To: Marc Perkel <mperkel@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 14:05:23, Marc Perkel wrote:
> In this new system setfacl, chmod, chown, and chgrp all go away  
> except inside of an emulation layer. File and directories no longer  
> have permissions. People have permission to naming patterns. So if  
> you put a file into a tree or move a tree then those who have  
> permissions to the tree have access to the files.
>
> It eliminates the step of having to apply permission after moving  
> files into a tree. You don't have to change file permissions  
> because files no longer have permissions.

And I'm trying to tell you that unless you have some magic new  
algorithm that turns NP-complete problems into O(log(N)) problems,  
your idea won't work.  You can't just say "I just do one little thing  
(mv) and the entire rest of the computer automagically changes to  
match", because that would imply a single unscalable global kernel  
lock.  "Pattern"-matching is either NP-complete or high-polynomial- 
order, depending on how its implemented, and if you want to do a  
recursive-chmod during a directory move then you're going to have  
race-conditions out the ass.  If you have code or solid math to back  
up your postings then please do so, but otherwise you're just wasting  
time and bandwidth.

Cheers,
Kyle Moffett

