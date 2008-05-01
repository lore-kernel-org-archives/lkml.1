Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbYEADRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbYEADRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759899AbYEADRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:17:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:48655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbYEADRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:17:12 -0400
Date: Wed, 30 Apr 2008 20:13:41 -0700
From: Greg KH <gregkh@suse.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 00/10] sysfs tagged directories
Message-ID: <20080501031341.GD4911@suse.de>
References: <20080429171015.473938697@theryb.frec.bull.fr> <20080429173621.GA16625@suse.de> <20080429180445.GA18110@sergelap.austin.ibm.com> <20080429184151.GA19794@suse.de> <20080429193417.GA19282@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429193417.GA19282@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:34:17PM -0500, Serge E. Hallyn wrote:
> Finally, to give an idea about how the trees end up looking, here is
> what I just did on my test box;
> 
> /usr/sbin/ip link add type veth
> mount --bind /mnt /mnt
> mkdir /mnt/sys
> mount --make-shared /mnt
> ns_exec -cmn /bin/sh  # unshare netns and mounts ns
>  # At this point, I still see eth0 and friends under /sys/class/net etc
> mount -t sysfs none /sys
>  # At this point, /sys/class/net has only lo0 and sit0, and
>  # /sys/devices/pci0000:00/0000:00:03.0/net:eth0 is a dead link
> mount --bind /sys /mnt/sys
> echo $$
> 	3050
> 
> (back in another shell):
> /usr/sbin/ip link set veth1 netns 3050
> 
> (back in container shell):
> /usr/sbin/ip link set veth1 name eth0
>  # Now /sys/devices/pci0000:00/0000:00:03.0/net:eth0 is a live link to
>  # the /sys/class/net/eth0 which is really the original veth1
> exit
> 
> ls /mnt/sys/class/net
>  # empty directory

What does this all look like without CONFIG_SYSFS_DEPRECATED enabled,
which is what all sane distros do these days.  That's going to change
the look of the tree for stuff like this a lot I think...

thanks,

greg k-h
