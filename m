Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbZCSUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbZCSUQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761092AbZCSUPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:15:53 -0400
Received: from baikonur.stro.at ([213.239.196.228]:46264 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760999AbZCSUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:15:52 -0400
Date: Thu, 19 Mar 2009 21:13:10 +0100
From: maximilian attems <max@stro.at>
To: Frans Pop <elendil@planet.nl>, 518412@bugs.debian.org
Cc: md@linux.it, Jon Masters <jcm@jonmasters.org>,
       linux-kernel@vger.kernel.org
Subject: linux-2.6 install errors due to incompatible depmod files [was Re: Bug#518412: initramfs-tools: must support relative paths in modules.dep ]
Message-ID: <20090319201310.GI3901@baikonur.stro.at>
References: <20090319153604.GB7954@stro.at> <200903191843.28437.elendil@planet.nl> <20090319181031.GH3901@baikonur.stro.at> <200903191940.47726.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903191940.47726.elendil@planet.nl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding jcm and lkml to Cc: ]



On Thu, Mar 19, 2009 at 07:40:46PM +0100, Frans Pop wrote:
> 
> Hmmm. I wonder if it is the old m-i-t's modprobe that is the problem when 
> you do:
> modprobe --set-version=2.6.26.3 --ignore-install --show-depends <module>
> 
> Looks like that's it:
> # modprobe -V
> module-init-tools version 3.4
> # modprobe --set-version=2.6.26.3 --ignore-install --show-depends nfs
> WARNING: Could not open 'kernel/net/sunrpc/sunrpc.ko': No such file or 
> directory
> WARNING: Could not open 'kernel/fs/nfs_common/nfs_acl.ko': No such file or 
> directory
> WARNING: Could not open 'kernel/fs/lockd/lockd.ko': No such file or 
> directory
> FATAL: Could not open 'kernel/fs/nfs/nfs.ko': No such file or directory
> 
> # modprobe -V
> module-init-tools version 3.7-pre9
> # modprobe --set-version=2.6.26.3 --ignore-install --show-depends nfs
> WARNING: All config files need .conf: /etc/modprobe.d/pnp-hotplug, it will 
> be ignored in a future release.
> WARNING: All config files need .conf: /etc/modprobe.d/display_class, it 
> will be ignored in a future release.
> WARNING: All config files need .conf: /etc/modprobe.d/blacklist, it will 
> be ignored in a future release.
> insmod /lib/modules/2.6.26.3/kernel/net/sunrpc/sunrpc.ko
> insmod /lib/modules/2.6.26.3/kernel/fs/nfs_common/nfs_acl.ko
> insmod /lib/modules/2.6.26.3/kernel/fs/lockd/lockd.ko
> insmod /lib/modules/2.6.26.3/kernel/fs/nfs/nfs.ko
> 
> That would mean that m-i-t has created a backwards incompatibility problem 
> _with itself_ and that the problem actually is "installing a kernel, that 
> was built on a system with new m-i-t, on a system with old m-i-t".
> Or, installing a kernel, built on a system running unstable or testing, on 
> a system running oldstable or stable. That sucks.

argh indeed.

arguably it is also a bug by initramfs-tools to suppress the error of above
modprobe calls see manual_add_modules() in hook-functions:
        for mam_x in $(modprobe --set-version="${version}" --ignore-install \
	--show-depends "${1}" 2>/dev/null | awk '/^insmod/ { print $2 }'); do


git history tells that jbailey added it from the start on,
so it must have been because modprobe was/is too chatty.
suse mkinitrd seems also only to have lost that suppression lately.

 

thanks for finding out fjp.

kind regards

-- 
maks
