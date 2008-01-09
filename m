Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYAITP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYAITP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYAITPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:15:18 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43093 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYAITPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:15:17 -0500
Date: Wed, 9 Jan 2008 20:14:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Build Fails on 2.6.24-rc6-mm1[drivers/net/iseries_veth.ko] linking error
Message-ID: <20080109191456.GB6880@uranus.ravnborg.org>
References: <20080109101404.GC1321@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109101404.GC1321@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 03:44:04PM +0530, Sudhir Kumar wrote:
> Hi Andrew,
> Build fails on my Power Machine with following error message.
> 
> 
>  HOSTLD  arch/powerpc/boot/dtc
>  WRAP    arch/powerpc/boot/zImage.pseries
>  WRAP    arch/powerpc/boot/zImage.pmac
> strip -s -R .comment vmlinux -o arch/powerpc/boot/zImage.iseries
>  Building modules, stage 2.
>  MODPOST 264 modules
> ERROR: ".driver_add_kobj" [drivers/net/iseries_veth.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

driver_add_kobj has a single user - iseries_veth. It is even documented
in the comment in the file.
And you build iseries_veth as a module but driver_add_kobj is not exported
which is why you get this modpost error.

Workaround: make the driver built-in
Fix: export driver_add_kobj or replace usage in iseries_veth.

	Sam
