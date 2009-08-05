Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZHEUzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZHEUzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZHEUzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:55:50 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59102 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZHEUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lk8YbX1vUyROLX3Qj+zIHPExsMrZn37/u6pFhEu948jzlXn0salTc/CbDUaWvzXpdT
         UIoktkforNRoMgYy+EkwybtComyWrztD52hg5yBva2FSK8nwF5qR63KHEWDqh1IXy4Qt
         fpqqdPtA7MGBF75c/tLyIid7EF9yBdkxPppiE=
MIME-Version: 1.0
In-Reply-To: <20090805171513.GA10443@kroah.com>
References: <20090805171513.GA10443@kroah.com>
Date: Wed, 5 Aug 2009 21:55:49 +0100
Message-ID: <9b2b86520908051355o79699e99ke045b635c6b443ad@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based 
	/dev
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/09, Greg KH <greg@kroah.com> wrote:
> Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.
> It's been tested and agreed by three major distros that this is a good
> idea.  SuSE has been shipping this in their kernels for a while now with
> no problems, and actual speedups measured on their boot times.  Gentoo
> also has been testing it, but we haven't gotten a tested-by: line from
> them yet, hopefully that will happen soon.
>
> A number of embedded distros have also privately said they would be
> using this patch, I really don't understand why they don't publically
> want to state this, but oh well...
>
> It's been in linux-next for many months now, with no reported
> regressions at all as well.
>
> thanks,
>
> greg k-h
>
> --------------
>
>
> From: Kay Sievers <kay.sievers@vrfy.org>
>
> Devtmpfs lets the kernel create a tmpfs instance called devtmpfs
> very early at kernel initialization, before any driver-core device
> is registered. Every device with a major/minor will provide a
> device node in devtmpfs.
>
> Devtmpfs can be changed and altered by userspace at any time,
> and in any way needed - just like today's udev-mounted tmpfs.
> Unmodified udev versions will run just fine on top of it, and will
> recognize an already existing kernel-created device node and use it.
> The default node permissions are root:root 0600. Proper permissions
> and user/group ownership, meaningful symlinks, all other policy still
> needs to be applied by userspace.

> +	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
> +			      path, LOOKUP_PARENT, &nd);
> +	if (err == 0) {
> +		struct dentry *dentry;
> +
> +		/* create directory right away */
> +		dentry = lookup_create(&nd, 1);
> +		if (!IS_ERR(dentry)) {
> +			err = vfs_mkdir(nd.path.dentry->d_inode,
> +					dentry, 0775);

Is there a typo here?  I think the mode should be 0755.   0755 is used
below, and that does fit better with the 0600 mode for device nodes.

Thanks
Alan
