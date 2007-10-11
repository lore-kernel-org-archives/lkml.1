Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXJKP5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXJKP5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXJKP5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:57:17 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:48254 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbXJKP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:57:16 -0400
To: haveblue@us.ibm.com
CC: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       haveblue@us.ibm.com
In-reply-to: <20071010163442.2228C7E9@kernel> (message from Dave Hansen on
	Wed, 10 Oct 2007 09:34:42 -0700)
Subject: Re: [RFC][PATCH 4/7] make open_namei() return a filp
References: <20071010163439.0F8089F7@kernel> <20071010163442.2228C7E9@kernel>
Message-Id: <E1IfztV-0007ru-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Oct 2007 17:24:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If open_namei() succeeds, there is potentially a mnt_want_write()
> that needs to get balanced.  If the caller doesn't create a
> 'struct file' and eventually __fput() it, or manually drop the
> write count on an error, we have a bug.
> 
> Forcing open_namei() to return a filp fixes this.  Any caller
> getting a 'struct file' back must consider that filp instantiated
> and fput() it normally.  The callers no longer have to worry about
> ever manually releasing a mnt write count.

I think this changelog is out of date, as this problem should have
been dealt with in patch-2/7.

Otherwise I don't object to this change, it looks like a fine cleanup.

Miklos
