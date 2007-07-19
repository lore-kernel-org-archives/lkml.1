Return-Path: <linux-kernel-owner+w=401wt.eu-S965300AbXGSQi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbXGSQi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937851AbXGSQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:38:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50805 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbXGSQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:38:13 -0400
Date: Thu, 19 Jul 2007 17:38:10 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jacob A <jacoba51-tmp@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
Message-ID: <20070719163810.GV21668@ftp.linux.org.uk>
References: <581196.34917.qm@web57713.mail.re3.yahoo.com> <Pine.LNX.4.64.0707191339090.30033@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707191339090.30033@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 01:41:03PM +0200, Jan Engelhardt wrote:
> 
> On Jul 19 2007 02:01, Jacob A wrote:
> >
> > How can a device driver go over the  list of all the files that are open on a
> > specific inode instance?
> 
> pseudo-code:
> 
> task_list_lock;
> for each process; do
> 	lock_fdtable;
> 	for each filedescriptor; do
> 		do_something(fd->file_ptr);
> 	unlock_fdtable;
> task_list_unlock;

Not again...

There are other things that can keep file open.  SCM_RIGHTS, references
held by syscall in progress, etc., etc.

The real question is why does driver want to do that?  Details, please...
