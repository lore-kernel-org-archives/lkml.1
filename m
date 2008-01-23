Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYAWSCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYAWSCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYAWSCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:02:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55690 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYAWSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:02:09 -0500
Date: Wed, 23 Jan 2008 19:02:08 +0100
From: Jan Kara <jack@suse.cz>
To: Rafael Sisto <rafael.sisto@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: create a file in kernel mode. help please!
Message-ID: <20080123180208.GD23304@atrey.karlin.mff.cuni.cz>
References: <ee3dc96c0801182116q3d54148dl6773d76ff3160d91@mail.gmail.com> <ee3dc96c0801182117t6e40b46fr1b2d5826e22a7124@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee3dc96c0801182117t6e40b46fr1b2d5826e22a7124@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> obviously this is a newbie question, but I couldn't find any
> documentation on how to do it.. I tried several ways but couldnt do
> it.
> I designed a system call, so a user will call it, and a new file will
> be created ('/tmp/filexx'). After that, I have another system call,
> that will map the file into the maps of the user process. The idea is
> the same as IPC...
> 
> I managed to create the file with this function (in the first system call):
>         fd = filp_open(path, O_CREAT | O_RDWR , 777);
> 
> After that, the user will call another system call, and it will map
> this file to the process maps.
> something like this:
>          filp_open(route, O_RDWR,0 );
>          do_mmap(fp, 0, tamano, PROT_READ | PROT_WRITE | PROT_EXEC,
> MAP_SHARED, 0);
> 
> After I call the second system call, the user tries to access the
> memory, but gets the message "Bus Error".
> I tried to manually create a file with vi, and then use the second
> system call, and worked perfectly. I could use the shared memory
> without problems.
> 
> The problems seems to be in the first system call (with filp_open),
> when I try to create a new file... Can somebody suggest me something,
> on how I could fix this issue?? It is very important because it is for
> a college projects.
  Hmm, I don't quite get what you are trying to achieve? Why can't user
create the file via open(path, O_CREAT...) and then mmap() it? Why do
you need a new system call for that?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
