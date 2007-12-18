Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXLRDBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXLRDBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXLRDBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:01:46 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:44804 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXLRDBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:01:45 -0500
Message-ID: <476738A0.9010601@cs.columbia.edu>
Date: Mon, 17 Dec 2007 22:04:00 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-fsdevel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp> <20071217194802.GA14156@sergelap.austin.ibm.com> <200712180003.lBI03N7F092396@www262.sakura.ne.jp> <20071218003955.GA27048@sergelap.austin.ibm.com> <476724E3.6060901@cs.columbia.edu> <20071218020933.GA28745@sergelap.austin.ibm.com>
In-Reply-To: <20071218020933.GA28745@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> I hate to bring this again, but what if the admin in the container
>> mounts an external file system (eg. nfs, usb, loop mount from a file,
>> or via fuse), and that file system already has a device that we would
>> like to ban inside that container ?
> 
> Miklos' user mount patches enforced that if !capable(CAP_MKNOD),
> then mnt->mnt_flags |= MNT_NODEV.  So that's no problem.

Yes, that works to disallow all device files from a mounted file system.

But it's a black and white thing: either they are all banned or allowed;
you can't have some devices allowed and others not, depending on type
A scenario where this may be useful is, for instance, if we some apps in
the container to execute withing a pre-made chroot (sub)tree within that
container.

> 
> But that's been pulled out of -mm! ?  Crap.
> 
>> Since anyway we will have to keep a white- (or black-) list of devices
>> that are permitted in a container, and that list may change even change
>> per container -- why not enforce the access control at the VFS layer ?
>> It's safer in the long run.
> 
> By that you mean more along the lines of Pavel's patch than my whitelist
> LSM, or you actually mean Tetsuo's filesystem (i assume you don't mean that
> by 'vfs layer' :), or something different entirely?

:)

By 'vfs' I mean at open() time, and not at mount(), or mknod() time.
Either yours or Pavel's; I tend to prefer not to use LSM as it may
collide with future security modules.

Oren.

> 
> thanks,
> -serge
