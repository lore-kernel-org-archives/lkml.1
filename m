Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbZJWMrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbZJWMrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZJWMrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:47:51 -0400
Received: from fifo99.com ([67.223.236.141]:37385 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZJWMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:47:50 -0400
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI
 table is present
From: Daniel Walker <dwalker@fifo99.com>
To: Erwan Velu <erwanaliasr1@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <4AE19867.5070705@gmail.com>
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu>
	 <4AE19867.5070705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Oct 2009 05:47:46 -0700
Message-Id: <1256302066.10493.74.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 13:49 +0200, Erwan Velu wrote:
> Ingo Molnar a écrit :
> > Looks like a Xen bug. DMI matching functions should be called after that 
> > code has initialized. The warning was added to catch such early calls.
> >
> > Your patch works around that bug and the warning.
> >   
> So I think you'll drop it and we have to make xen people fix it ?

It's your defect, so you can still try to fix it (unless the "xen
people" or someone else beats you to it.) 

It looks like on a normal system dmi_scan_machine() gets called very
early in setup_arch() arch/x86/kernel/setup.c . A possible good fix
might be to add a dmi_disable() into the dmi driver that just shuts off
dmi, and run that in xen_arch_setup() in arch/x86/xen/setup.c .

Daniel



