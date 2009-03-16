Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbZCPSJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbZCPSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZCPSJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:09:16 -0400
Received: from kroah.org ([198.145.64.141]:53672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754651AbZCPSJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:09:15 -0400
Date: Mon, 16 Mar 2009 11:05:38 -0700
From: Greg KH <greg@kroah.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries
Message-ID: <20090316180538.GA7069@kroah.com>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 04:20:33PM +0900, J. R. Okajima wrote:
> initial commit
> sysfs entries, compiled only when CONFIG_SYSFS is enabled

debug stuff should be in debugfs, not sysfs.

Also, any sysfs files that are created, need to be documented in
Documentation/ABI/.

> +#ifdef CONFIG_AUFS_DEBUG
> +static ssize_t debug_show(struct kobject *kobj __maybe_unused,
> +			  struct kobj_attribute *attr __maybe_unused,
> +			  char *buf)
> +{
> +	return sprintf(buf, "%d\n", au_debug_test());
> +}
> +
> +static ssize_t debug_store(struct kobject *kobj __maybe_unused,
> +			   struct kobj_attribute *attr __maybe_unused,
> +			   const char *buf, size_t sz)
> +{
> +	if (unlikely(!sz || (*buf != '0' && *buf != '1')))
> +		return -EOPNOTSUPP;
> +
> +	if (*buf == '0')
> +		au_debug(0);
> +	else if (*buf == '1')
> +		au_debug(1);
> +	return sz;
> +}

This should be a simple module parameter, like almost all drivers have
it.  That way it shows up in /sys/modules/aufs/ properly, as a boolean
value.  No need to reinvent the wheel here.

> +/* todo: file size may exceed PAGE_SIZE */
> +ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
> +			 char *buf)

NO IT CAN NOT!!!!

You are using sysfs wrong if you even think you are getting close to
PAGE_SIZE.

Please, use debugfs for this.  sysfs is a "one value per file" type
filesystem.  You should never be using the seqfile interface for a sysfs
file, that's a sure sign something is wrong in your design.

I think I'll stop reading now :(

thanks,

greg k-h
