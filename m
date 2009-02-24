Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZBXB1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZBXB1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZBXB1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:27:22 -0500
Received: from ozlabs.org ([203.10.76.45]:53834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZBXB1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:27:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andreas Robinson <andr345@gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Tue, 24 Feb 2009 11:57:10 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <1234952753.10531.48.camel@andreas-laptop> <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
In-Reply-To: <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241157.12067.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 11:07:05 Andreas Robinson wrote:
> 1. Monolithic:  6.27 s, (0.22). bzImg=3419 kB ramfs=515 kB
> 2. Megamodule:  6.80 s, (0.16). bzImg=2297 kB ramfs=1783 kB
> 3. Insmod list: 6.83 s, (0.07). bzImg=2297 kB ramfs=1942 kB
> 
> 10 samples were taken in each case. Standard deviations are in parenthesis.
> The measured times are printk timestamps from a dummy module inserted last.
> 
> Reading these benchmark results I can only conclude that my work is
> useless and life has no meaning.

I know that feeling!  Performance work tends to be like that.  I assume this
is an unpatched kernel, or did you apply some of the stop_machine prevention
/ lock reduction patches?
 
> So, what's missing or been done wrong here? I expected the difference
> between monolithic and modular to be greater to be honest.

modprobe vs insmod?

You could try copying /lib/modules/`uname -r`/modules.* and using modprobe,
see if the slowdown is actually there.

Thanks for chasing this!
Rusty.
Rusty.
