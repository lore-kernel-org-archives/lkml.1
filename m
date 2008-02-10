Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYBJLPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYBJLPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYBJLPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:15:30 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36080 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYBJLP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:15:29 -0500
Date: Sun, 10 Feb 2008 12:15:25 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
Message-ID: <20080210111525.GA28522@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
> only if the arch actually supports it.

This makes headers_install_all unreliable.
linux/kvm.h will not be exported, depending on what system the libc
headers will be generated. Please revert
fb56dbb31c4738a3918db81fd24da732ce3b4ae6 and find a different way to run
make headers_check successfully.

Similar CONFIG_* usage is in include/asm-cris/Kbuild.
Fortunately, its not relevant in practice.
