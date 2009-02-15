Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZBOH7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZBOH7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 02:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBOH7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 02:59:45 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:51479 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZBOH7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 02:59:45 -0500
Date: Sun, 15 Feb 2009 09:01:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Hunt <josh@scalex86.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       kiran@scalex86.org, mingo@elte.hu
Subject: Re: [PATCH] Add vmlinux to kernel rpm - updated description
Message-ID: <20090215080136.GA26481@uranus.ravnborg.org>
References: <20090212051057.GC12732@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212051057.GC12732@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 09:10:57PM -0800, Josh Hunt wrote:
> Resending with updated description:
> 
> We are building an automated system to test kernels weekly and need to
> provide an rpm to our QA dept.  We would like to use the ability to create
> kernel rpms already in the kernel's Makefile, but need the vmlinux file
> included in the rpm for later debugging.  This patch adds a compressed vmlinux to
> the kernel rpm when doing a make rpm-pkg or binrpm-pkg and upon install
> places the vmlinux file in /boot.
> 
> Signed-off-by: Josh Hunt <josh@scalex86.org>

Applied, but...

> 
> Index: linux-2.6.28/scripts/package/mkspec
> ===================================================================
> --- linux-2.6.28.orig/scripts/package/mkspec    2008-12-24
> 15:26:37.000000000 -0800
> +++ linux-2.6.28/scripts/package/mkspec    2009-01-21
> 16:53:03.000000000 -0800
> @@ -86,6 +86,14 @@ echo "%endif"
>  echo 'cp System.map $RPM_BUILD_ROOT'"/boot/System.map-$KERNELRELEASE"
> 
>  echo 'cp .config $RPM_BUILD_ROOT'"/boot/config-$KERNELRELEASE"
> +
> +echo "%ifnarch ppc64"
> +echo 'cp vmlinux vmlinux.orig'
why is this relevant for all architectures except ppc64?
This is not addressed neither in a comment nor in the changelog.

	Sam
