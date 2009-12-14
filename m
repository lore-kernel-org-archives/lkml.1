Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZLNBuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZLNBuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZLNBuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:50:07 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:51485 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZLNBuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=JyU0x91kqTBJg0SWy8poamzqNpiw+fPijULoITXyoWks1YUc2hlsfb+G7sHX12+UlE
         AjML6C6MfN5zoT2fxSGEqP5FsP216nSwhtSMZM7o44ztkTU2uTJMU/FTPNNNgrbE7FFi
         d8hTARwW0Uu9MgymzCBmrmduDxT8lkSrXakSA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
References: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 13 Dec 2009 20:49:42 -0500
Message-ID: <8bd0f97a0912131749j3fc1d539m8b65c960026d3535@mail.gmail.com>
Subject: Re: [PATCH] Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME 
	architecture support
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>,
       Chris Zankel <chris@zankel.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 14:21, Geert Uytterhoeven wrote:
> As of commit ee18d64c1f632043a02e6f5ba5e045bb26a5465f ("KEYS: Add a keyctl to
> install a process's session keyring on its parent [try #6]"), CONFIG_KEYS=y
> fails to build on architectures that haven't implemented TIF_NOTIFY_RESUME yet:
>
> security/keys/keyctl.c: In function 'keyctl_session_to_parent':
> security/keys/keyctl.c:1312: error: 'TIF_NOTIFY_RESUME' undeclared (first use in this function)
> security/keys/keyctl.c:1312: error: (Each undeclared identifier is reported only once
> security/keys/keyctl.c:1312: error: for each function it appears in.)
>
> Make KEYCTL_SESSION_TO_PARENT depend on TIF_NOTIFY_RESUME until blackfin,
> m68k, and xtensa have implemented it.

i'll be pushing a patch for 2.6.32 to add notify support to Blackfin ;)

but othewise, Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
