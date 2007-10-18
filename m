Return-Path: <linux-kernel-owner+w=401wt.eu-S1764713AbXJRSCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764713AbXJRSCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 14:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXJRSBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 14:01:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39633 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbXJRSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 14:01:54 -0400
Date: Thu, 18 Oct 2007 19:01:52 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is the inode an orphan?
Message-ID: <20071018180152.GO8181@ftp.linux.org.uk>
References: <47179CAE.6010806@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47179CAE.6010806@yandex.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 08:49:34PM +0300, Artem Bityutskiy wrote:
> Hi,
> 
> I need a help from VFS folks: when I'm in ->unlink() in is there a safe way 
> to to realize that ->delete_inod()e is going to be called? IOW, I'd like to 
> call myfs_delete_inode() myself form ->unlink(), and not wait for VFS 
> calling ->delete_inode().
> 
> Or to put it differently, I'd like to know if the inode is an orphan or not 
> in ->unlink()?
> 
> AFAICS, if (inode->i_nlink == 0 && atomic_read(&inode->i_count) == 2) then 
> this file is not going to be an orphan. And AFAIC judge, it is safe to use 
>  this, but I'm not sure and kindly ask for help.

Define orphan.  It might very well be still opened after the only link
to it had been removed and you still will get IO on it.
