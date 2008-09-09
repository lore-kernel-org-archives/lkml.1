Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYIIHEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYIIHEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYIIHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:04:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:7497 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYIIHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uhGzn/a9CQqNwxKxppcJcNh3kF+UP5iDG/XfgiNVa3InMtm5ZrK41iUpLOzWzley8i
         cGSXqxgj40N1tVNDM3YBXYyitirsFUzy+RIZWmvsCayQnvAiqu3imqBKWOFumdMKZNDF
         L+qZ4fpdn5NWqqf8cQyZR2w4cIjc2G04puE5M=
Date: Tue, 9 Sep 2008 11:06:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Message-ID: <20080909070603.GA5786@x200.localdomain>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 12:05:45AM -0400, Jarod Wilson wrote:
> The following patch series adds 17 new drivers for assorted infrared and/or RF
> remote control receivers and/or transmitters. These drivers have long lived
> out-of-tree at http://www.lirc.org/, packaged as 3rd-party modules by many
> distributions, and more recently, patched into the kernels of at least Fedora
> and Ubuntu.

Woo-hoo! One Vista-compatible (oh how it's called) remote control was
waiting for this!

All version.h and autoconf.h inclusions aren't needed.

#ifdef MODULE is gross and very old. Don't need that. Just use

	static int __init x_init(void)
	{
		...
	}

	static void __exit x_exit(void)
	{
		...
	}
	module_init(x_init);
	module_exit(x_exit);
	MODULE_LICENSE
		...

It will work correctly in modular and built-in case.

Static number of devices is simple but how about adding them dynamically.
