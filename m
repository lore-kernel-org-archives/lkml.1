Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbXCHE1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbXCHE1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbXCHE1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:27:30 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47174 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbXCHE13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:27:29 -0500
Date: Thu, 8 Mar 2007 09:55:44 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 11/20] x86_64: wakeup.S misc cleanups
Message-ID: <20070308042544.GC6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <20070307071320.GL23412@in.ibm.com> <20070307224053.GC5956@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307224053.GC5956@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:40:53PM +0100, Pavel Machek wrote:
> Hi!
> 
> > o Various cleanups. One of the main purpose of cleanups is that make
> >   wakeup.S as close as possible to trampoline.S.
> > 
> > o Following are the changes
> > 	- Indentations for comments.
> > 	- Changed the gdt table to compact form and to resemble the
> > 	  one in trampoline.S
> > 	- Take the jump to 32bit from real mode using ljmpl. Makes code
> > 	  more readable.
> > 	- After enabling long mode, directly take a long jump for 64bit
> > 	  mode. No need to take an extra jump to "reach_comaptibility_mode"
> > 	- Stack is not used after real mode. So don't load stack in
> >  	  32 bit mode.
> > 	- No need to enable PGE here.
> > 	- No need to do extra EFER read, anyway we trash the read contents.
> > 	- No need to enable system call (EFER_SCE). Anyway it will be 
> > 	  enabled when original EFER is restored.
> > 	- No need to set MP, ET, NE, WP, AM bits in cr0. Very soon we will
> >   	  reload the original cr0 while restroing the processor state.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> > Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> 
> ACK, provided it was tested.
> 									Pavel

Hi Pavel,

Thanks. I tested all the S3 related changes during my last posting. That
time I had access to an x86_64 box which supported ACPI state S3. Since then
this code has not changed and it has been running successfully in RHEL5 
kernels. Now I don't have access to an x86_64 machine which supports S3
so I can't test suspend to RAM. But I am sure that these patches are working
as nothing has changed since last posting.

Just now Nigel reported successful suspend to RAM results for 2.6.20. I
have requested him to test it for 2.6.21-rc2 also, if possible.

I have throughly tested suspend to disk (S4) and it works fine.

Thanks
Vivek
