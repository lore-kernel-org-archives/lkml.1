Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYE1W5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYE1W5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYE1W5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:57:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbYE1W5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:57:33 -0400
Date: Wed, 28 May 2008 15:57:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/1] Char: vt, make sysfs operations atomic
Message-Id: <20080528155719.3114d54f.akpm@linux-foundation.org>
In-Reply-To: <20080527204858.GI5713@cathedrallabs.org>
References: <1211802812-13658-1-git-send-email-jirislaby@gmail.com>
	<20080527194357.GA12185@cathedrallabs.org>
	<483C6EAE.4050401@gmail.com>
	<20080527204858.GI5713@cathedrallabs.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 16:48:58 -0400
Aristeu Rozanski <aris@ruivo.org> wrote:

> >> the reason for the code be the way it is is because vcs_{add,remove}_sysfs()
> >> may sleep
> >
> > What's the point? To have races in the code but not sleep inside the semaphore?
> what about fixing the code to remove the race _and_ not sleep inside the
> semaphore? :)
> 

The patch does fix a race, by extending console_sem coverage to provide
exclusion between the sysfs creation and teardown operations.

I assume - no race was identified in the changelog.  Can we actually
simultaneously run con_open() and con_close() against the same device? 
I guess it might be possible if userspace tried hard enough.

I renamed the patch to the much more accurate "vt: hold console_sem
across sysfs operations" - "atomic" in the kernel context means "cannot
context switch" and nothing "atomic" is happening in this patch.

