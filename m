Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXBDCwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXBDCwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXBDCwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:52:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:57851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXBDCwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:52:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Sun, 4 Feb 2007 03:52:03 +0100
User-Agent: KMail/1.9.5
Cc: Maynard Johnson <maynardj@us.ibm.com>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <45BE4ED0.5030808@us.ibm.com> <200701300839.05144.arnd@arndb.de> <45C51F6C.7080300@us.ibm.com>
In-Reply-To: <45C51F6C.7080300@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702040352.03792.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+ZTbsByg5ZnSQFosL9eOpfjYWO8C4+2QiJNfsaGCGoco1VB0qeJ3RhnLCSheX1ZJoNpEq5A+Lh11L9rxYGM4Is3Nx7CLtFmLuTsoVjGoB0Sw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 February 2007 00:49, Maynard Johnson wrote:
> I seem to recall looking at this option a while back, but didn't go that 
> route since struct spu_context is opaque to me.  With such a teqnique, I 
> could then use a simple 16-element array of  pointers to cached_info 
> objects, creating them as needed when spu_context->profile_private is 
> NULL.  I suppose the better option for now is to add a 
> get_profile_private() function to SPUFs, rather than requiring 
> spu_context to be visible.

Yes, that sounds good. Note that the file providing the 
spufs_get_profile_private (and respective spufs_set_profile_private)
functions needs to be compiled into the kernel then in case oprofile
gets linked in but spufs is a module.

I think it would also be necessary to have another interface for cleaning
up this data when spufs destroys the context. That could possibly
a variation of the existing notifier call, or a new call, or you
establish the convention that if the private pointer is non-NULL,
spufs will kfree it.

	Arnd <><
