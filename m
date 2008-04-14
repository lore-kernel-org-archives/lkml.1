Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbYDNSjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbYDNSjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762277AbYDNSjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:39:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37562 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761697AbYDNSjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oB9YcMw+AFDKg1obRz20hWA5e0QxOmsNRedpEdWXmWEBYKNXA0VMfAZJcoMrvGfsDo3Xu22QI7IPcDk12nOhLnhkbf2ZIJThTKVxbDGJVGTzNXOW1XyUZNc44QsvsWU2Dxa0NfvyETN+un8vkwGwZRNm6686ONASeCZJdjGk+Wg=
Date: Mon, 14 Apr 2008 22:34:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414183434.GB5234@martell.zuzino.mipt.ru>
References: <ah5DA-3X9-9@gated-at.bofh.it> <ah5X5-4tl-13@gated-at.bofh.it> <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414175452.27c3652d@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414175452.27c3652d@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 05:54:52PM +0100, Alan Cox wrote:
> >   Well, but imagine you have a file /proc/my_secret_file from which you
> > are able to read from position A:a and B:b but not from position
> > A:b. Concievably, checks for the file position could be bypassed because of
> > this race... I know this is kind of dumb example but I can imagine someone
> 
> Unlikely as the ppos passed to the driver is a private copy and the user
> could equally use pread/pwrite to specify that offset.

pread is banned on proc files implemented via seq_files.
And in no-seq_file case, there are MAX_NON_LFS checks which fits into
32 bits.

