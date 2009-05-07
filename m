Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZEGVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZEGVYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZEGVYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:24:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49074 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZEGVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:24:24 -0400
Date: Thu, 7 May 2009 14:24:29 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
       jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single and multiple-instance
	mounts
Message-ID: <20090507212429.GA24064@linux.vnet.ibm.com>
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris [eparis@parisplace.org] wrote:
| On Sat, Mar 7, 2009 at 2:12 PM, Sukadev Bhattiprolu
| <sukadev@linux.vnet.ibm.com> wrote:
| >
| > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| > Subject: [v3][PATCH 5/5] Merge code for single and multiple-instance mounts
| 
| I just tried to load the linux-next kernel on F11 and ran into a
| problem.  X started, I could log in, I could start programs like
| firefox and evolution, but not gnome-terminal.  It would just flash
| and disappear.  Running xterm resulted in a window, that I could type
| in, but it wasn't a shell.  It didn't do anything.
| 
| I switched to vt2 set the display to my X session and tried to run
| xterm.  It said something about a permission being denied, so I
| decided to strace it.  I saw EACCESS returning from calls dealing with
| /dev/pts/0.  This lead me to git bisect start fs/devpts from the
| latest in linux-next as bad and 2.6.29 as good.  Couple interations
| later and I find that this commit (1bd7903560f1f7) breaks
| gnome-terminal xterm!

Interesting :-) -EACCESS makes me suspect that maybe 'mode' 'uid' or 'gid'
mount options are wrong. Of course we would still need to understand if/
why this patch changes the settings.

Can you paste the output of following commands: (both in success and failure
cases).

	$ grep devpts /proc/mounts

	$ ls -al /dev/pts

	$ stat /dev/ptmx

Also, is CONFIG_DEVPTS_MULTIPLE_INSTANCES set in your .config ?

With this patch, does gnome-terminal run when logged in as root ?

Thanks,

Sukadev
