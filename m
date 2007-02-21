Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbXBULZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbXBULZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXBULZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:25:37 -0500
Received: from ns.suse.de ([195.135.220.2]:41932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbXBULZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:25:36 -0500
From: Neil Brown <neilb@suse.de>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Date: Wed, 21 Feb 2007 22:24:49 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17884.11265.145106.290158@notabene.brown>
Cc: nfs@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.13.4 - "lockd: weird return 1 for CANCEL call"
In-Reply-To: message from Jesper Juhl on Wednesday February 21
References: <9a8748490702210246j38a1ca4bi8de371ba6829ada9@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday February 21, jesper.juhl@gmail.com wrote:
> Greetings,
> 
> I just got a unusual message from lockd on a webserver running a
> custom compiled 2.6.13.4 (yes it is ancient, I know).
> 
> # uname -a
> Linux webserv.somedomain.example 2.6.13.4 #1 SMP Wed Nov 16 10:03:05
> CET 2005 i686 unknown
> 
> # dmesg | tail -n 3
> do_vfs_lock: VFS is out of sync with lock manager!
> lockd: weird return 1 for CANCEL call
> lockd: weird return 1 for CANCEL call
> 
> The server seems to be running fine, so I'm not really worried, but I
> thought maybe someone would like to know. :-)

Thanks.
Don't be worried.  They are both warning about perfectly acceptable
(though uncommon) behaviour.  These warnings have since been removed.

A process was interrupted while trying to get a lock, so the NFS
client didn't know if it actually had the lock or not.
When the process exited, the tried to cancel the lock just to be on
the safe side and was told that it didn't own any such lock.

NeilBrown
