Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbXGSNUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbXGSNUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbXGSNUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:20:01 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:39480 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbXGSNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:20:00 -0400
Date: Thu, 19 Jul 2007 09:19:56 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Jim Kovaric <jkovaric@us.ibm.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, serue@linux.vnet.ibm.com
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <Line.LNX.4.64.0707190901200.4393@d.namei>
Message-ID: <Line.LNX.4.64.0707190912520.4393@d.namei>
References: <OF54A17BCF.9A1D7004-ON8725731D.0044828E-8625731D.0046CAED@us.ibm.com>
 <Line.LNX.4.64.0707190901200.4393@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, James Morris wrote:

> On Thu, 19 Jul 2007, Jim Kovaric wrote:
> 
> > IBMs  TAMOS (Tivoli Access Manager for Operating systems) contains a 
> > loadable module,
> >  which is an "out of tree module",  and registers "itself"  as a security 
> > module during the TAMOS startup
> > process. It also requires that SElinux  be "disabled"
> 
> Please provide a link to the source code, so we can understand how you're 
> using the API.

I think I've found it:

ftp://ftp.software.ibm.com/software/tivoli_support/patches/patches_6.0.0/6.0.0-TIV-PDO-FP0007/6.0.0-TIV-PDO-Linux.i386-FP0007.tar

Is that correct?

  kail_trap_syscalls() 

seems to be revectoring the syscall table and siliently disabling any 
active LSM.


  kail_restore_syscalls()

attempts to restore them on module unload.


Is my understanding correct?

You're shipping this to customers as a security feature?


- James
-- 
James Morris
<jmorris@namei.org>
