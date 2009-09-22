Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZIVT7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZIVT7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZIVT7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:59:48 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:58651
	"EHLO QMTA06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZIVT7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:59:47 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2009 15:59:47 EDT
Date: Tue, 22 Sep 2009 14:53:53 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Brian McGrew <brian@visionpro.com>
Cc: Luciano Rocha <luciano@eurotux.com>, linux-kernel@vger.kernel.org
Subject: Re: (un)mount ramfs from C code
Message-ID: <20090922195353.GB22458@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
Mail-Followup-To: Tim Walberg <twalberg@comcast.net>,
	Brian McGrew <brian@visionpro.com>,
	Luciano Rocha <luciano@eurotux.com>, linux-kernel@vger.kernel.org
References: <20090922162658.GB7973@bit.office.eurotux.com> <C6DE73D6.12872%brian@visionpro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6DE73D6.12872%brian@visionpro.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mount(2) (i.e. the system-call/library function) does not update /etc/mtab, IIRC...
mount(8) (the command-line utility) does...

In either case, I would expect the mount to show up in /proc/mounts (assuming
/proc is mounted).



On 09/22/2009 12:30 -0700, Brian McGrew wrote:
>>	> You mean without using system(3), right? System call is how your program
>>	> interacts with the outside world.
>>	> 
>>	> The relevant system calls are:
>>	>   - mount(2): mount("none", "/mnt", "ramfs", 0, NULL);
>>	>   - umount(2): umount("/mnt");
>>	> 
>>	
>>	Thanks for the help!  I'm getting there.  Considering the following:
>>	
>>	If (mount("ramfs", rd_path, "ramfs", MS_NOEXEC | MS_NOSUID, "size=2000m") <
>>	0) {
>>	    strerror(errno);
>>	} else {
>>	    std::cout << "mounted";
>>	}
>>	
>>	Works great!  Thank you.  However, even though the filesystem is mounted and
>>	/bin/mountpoint confirms it's a mountpoint, I do not see the mountpoint
>>	listed in /etc/mtab.
>>	
>>	Also, according to what I've read about ramfs, the size is supposed to be
>>	limited to size=, however, I can cat /dev/zero until the box it out of
>>	memory (and swap).
>>	
>>	I think I'm just missing something and google's not helping a whole lot
>>	since ramfs isn't the most popular subject today.
>>	
>>	Thanks,
>>	
>>	-b
>>	
>>	--
>>	To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>	Please read the FAQ at  http://www.tux.org/lkml/
End of included message



-- 
twalberg@comcast.net
