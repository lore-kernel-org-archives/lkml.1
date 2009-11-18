Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZKRD4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZKRD4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZKRD4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:56:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:34203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZKRD4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:56:07 -0500
Date: Tue, 17 Nov 2009 19:44:50 -0800
From: Greg KH <gregkh@suse.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, root@localdomain.pl,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devpts_get_tty() should validate inode
Message-ID: <20091118034450.GB17349@suse.de>
References: <20091118023541.GA14430@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118023541.GA14430@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 06:35:43PM -0800, Sukadev Bhattiprolu wrote:
> 
> devpts_get_tty() assumes that the inode passed in is associated with a valid
> pty.  But if the only reference to the pty is via a bind-mount, the inode
> passed to devpts_get_tty() while valid, would refer to a pty that no longer
> exists.
> 
> With a lot of debug effort, Grzegorz Nosek developed a small program (see
> below) to reproduce a crash on recent kernels. This crash is a regression
> introduced by the commit:
> 
> 	commit 527b3e4773628b30d03323a2cb5fb0d84441990f
> 	Author: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> 	Date:   Mon Oct 13 10:43:08 2008 +0100
> 
> To fix, ensure that the dentry associated with the inode has not yet been
> deleted/unhashed by devpts_pty_kill().
> 
> See also:
> https://lists.linux-foundation.org/pipermail/containers/2009-July/019273.html 

Good debugging, I'll queue this up.

greg k-h
