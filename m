Return-Path: <linux-kernel-owner+w=401wt.eu-S1751374AbXBMWjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbXBMWjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXBMWjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:39:53 -0500
Received: from ns1.suse.de ([195.135.220.2]:51026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXBMWjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:39:52 -0500
From: Neil Brown <neilb@suse.de>
To: Greg KH <greg@kroah.com>
Date: Wed, 14 Feb 2007 09:39:10 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17874.15886.523387.629797@notabene.brown>
Cc: Andreas Gruenbacher <agruen@suse.de>, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
In-Reply-To: message from Greg KH on Tuesday February 13
References: <20070213195116.GA5181@kroah.com>
	<200702131158.02809.agruen@suse.de>
	<20070213213737.GA14383@kroah.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 13, greg@kroah.com wrote:
> 
> This causes the following to just loop over and over, incrementing the
> pid:
> 
> gnome-vfs-daemo(8914): 

That's odd.  getcwd returning an empty string.
I can only see that happening if you do the equivalent of
   chdir("/");
   chroot("/somewhere");
   getcwd(buf,sizeof(buf));

That would return an empty string with the new code but not with the
old.
But I cannot imagine gnome-vfs-daemon doing a chroot, as it does not
run as root.

You could try removing the
		if (*buffer == '/') {
			buffer++;
			buflen++;
		}
from the new __d_path.  But that still wouldn't really explain what
was happening.

Maybe also put a WARN_ON(! *buffer) just before the return to find out
exactly what is going on when the empty string is returned.

NeilBrown
