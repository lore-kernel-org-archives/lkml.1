Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYCRLed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYCRLed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYCRLeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:34:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59718 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYCRLeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:34:17 -0400
To: jmorris@namei.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, eparis@redhat.com,
       linux-security-module@vger.kernel.org
In-reply-to: <Xine.LNX.4.64.0803180947230.10104@us.intercode.com.au> (message
	from James Morris on Tue, 18 Mar 2008 09:51:10 +1100 (EST))
Subject: Re: [patch 00/11] mount ownership and unprivileged mount syscall
 (v9)
References: <20080317200053.447640802@szeredi.hu> <Xine.LNX.4.64.0803180947230.10104@us.intercode.com.au>
Message-Id: <E1Jba3y-0005eS-LX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Mar 2008 12:33:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Something to consider down the track would be how to possibly allow this 
> with SELinux, which only knows about normal mounts.

Right.

> We might need a user_mount hook which is called once the core kernel code 
> determines that it is a a valid unprivileged mount (although the sb_mount 
> hook will already have been called, IIUC).

Does the order matter between core code's and the security module's
permission checks?  If it does, the cleanest would be to just move the
core checks before the sb_mount hook, no?

Miklos
