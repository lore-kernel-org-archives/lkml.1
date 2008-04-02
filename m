Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYDBQy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYDBQy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYDBQys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:54:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42485 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYDBQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:54:47 -0400
Date: Wed, 2 Apr 2008 12:54:27 -0400
Message-Id: <200804021654.m32GsRnI020433@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Tomas M <tomas@slax.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [GIT PULL -mm] 00/14 VFS/Unionfs updates/fixes/cleanups 
In-reply-to: Your message of "Wed, 02 Apr 2008 15:48:00 +0200."
             <47F38E90.20306@slax.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <47F38E90.20306@slax.org>, Tomas M writes:

> > 1. Based on recommendations we've received while at LSF'08, we've changed
> >    Unionfs to use the vm_operations->fault method, instead of
> >    address_space_operations.
[...]
> May I ask you, why did it took so long?
> Mainly, why did you refused to make the changes last year?
> 
> Thank you
> 
> Tomas M

The current ->fault API requires (IMHO) an ugly hack such as this:

1. get the upper file pointer from vma->vm_file
2. get the lower file from the upper file
3. *override* the vma->vm_file pointer with the lower file
4. call the lower ->fault op with the changed vma->vm_file pointer
5. upon return, *reset* the vma->vm_file pointer back to its original value
   (i.e., pointing to the upper file)

Steps 3 and 5 require this "pointer flipping" that I was sure was
unacceptable to kernel developers who might be reviewing the code.  I didn't
want to use this technique before I've had the sanctioning of the
appropriate kernel maintainers, along with an acceptable path to fix the
->fault API.  LSF was an excellent opportunity to discuss this and many
other related issues in person.

Cheers,
Erez.
