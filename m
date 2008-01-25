Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYAYAKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYAYAKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYAYAKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:10:31 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52476 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYAYAKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:10:30 -0500
Date: Thu, 24 Jan 2008 19:09:28 -0500
Message-Id: <200801250009.m0P09SBe010417@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Al Viro <viro@ftp.linux.org.uk>, David Howells <dhowells@redhat.com>,
       William H Taber <wtaber@us.ibm.com>,
       William Cesar de Oliveira <owilliam@br.ibm.com>,
       Richard Kissel <rkissel@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Fix procfs task exe symlink 
In-reply-to: Your message of "Wed, 23 Jan 2008 20:01:05 +0100."
             <Pine.LNX.4.64.0801231945530.12676@fbirervta.pbzchgretzou.qr> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0801231945530.12676@fbirervta.pbzchgretzou.qr>, Jan Engelhardt writes:
> 
> On Jan 23 2008 10:29, Matt Helsley wrote:
> >
> >For executables on the stackable MVFS filesystem the current procfs
> >methods for implementing a task's exe symlink do not point to the
> >correct file and applications relying on the symlink fail (see the
> >java example below).
> 
> This reminds me of unoionfs - it also had this issue, but IIRC,
> it eventually got solved. (Should now display /union/exe rather
> than /lowerlevel/exe.) Unionfs developers should know more.

Unionfs resolved this by fully implementing the address_space ops, as well
as ->mmap (i.e., one cannot "cheat" and inherit the lower address_space).

Erez.
