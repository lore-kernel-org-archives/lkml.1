Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbYIHAhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbYIHAhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYIHAhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:37:10 -0400
Received: from smtp.knology.net ([24.214.63.101]:59506 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYIHAhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:37:09 -0400
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
From: David Dillow <dave@thedillows.org>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, joerg.roedel@amd.com,
       rjmaomao@gmail.com
In-Reply-To: <20080907234510.GA24133@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu>
	 <20080907234510.GA24133@yantp.cn.ibm.com>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 20:36:56 -0400
Message-Id: <1220834216.1837.11.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 07:45 +0800, Yan Li wrote:
> +int is_vmware_guest(void)
> +{
> +	u32 version[3];
> +
> +	getVersion(&version[0]);
> +
> +	if (version[1] != BDOOR_MAGIC) {
> +		/* Incorrect virtual machine version */
> +		return 0;
> +	}
> +
> +	if (version[0] != VERSION_MAGIC) {
> +		/* Incorrect version magic */
> +		return 0;
> +	}
> +
> +	/* Yes, we are running as VMware Guest */
> +	printk(KERN_INFO "vmware detected\n");
> +	return 1;
> +}

If you want this to be used by more callsites, it probably doesn't make
sense to have it print out a message each time.

In fact would it make more sense to have a framework (cpu feature flag?)
to detect that we're in any virtualized environment and make this one of
the detection routines, and perhaps cache the result. Especially if this
detection would be used to manage anything near a hot-path in the page
cache as you suggested.

But maybe that's overkill.

