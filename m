Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYEEH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYEEH3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYEEH3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:29:07 -0400
Received: from 1wt.eu ([62.212.114.60]:4112 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYEEH3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:29:05 -0400
Date: Mon, 5 May 2008 09:28:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount point inside a read only filesystem
Message-ID: <20080505072824.GE14635@1wt.eu>
References: <18456.34604.472989.35082@ipc1.ka-ro> <20080501215231.297e0d9d.akpm@linux-foundation.org> <53722.192.168.1.70.1209711343.squirrel@neil.brown.name> <20080503063231.GA688@1wt.eu> <18462.43245.728465.911831@ipc1.ka-ro> <20080505070214.GA14635@1wt.eu> <18462.45648.60033.233887@ipc1.ka-ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18462.45648.60033.233887@ipc1.ka-ro>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:08:00AM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Willy Tarreau writes:
> > > > open(".", O_RDONLY|O_LARGEFILE|O_DIRECTORY) = 3
> > > > chdir("/")                              = 0
> > > > mkdir("dev", 0755)                      = -1 EEXIST (File exists)
>                                                    ^^^^^^
> [...]
> > > This is what strace shows in my case:
> > > mkdir("/", 0777)                        = -1 EEXIST (File exists)
> > > stat64("/", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
> > > mkdir("/dev/", 0777)                    = -1 EROFS (Read-only file system)
>                                                  ^^^^^
> > What puzzles me is why you have this problem only with a new kernel.
> > I suspect that previous ones did report EEXIST and now we report
> > EROFS for an existing directory on an ro fs.
> > 
> Interestingly your strace output showed a return value of EEXIST where
> mine had EROFS.

Oh you're right! I did not notice. There's something odd here.
And I can reproduce it right now (2.6.25.1). I really have
EEXIST.

Willy

