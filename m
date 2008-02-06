Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYBFUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYBFUNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYBFUNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:13:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYBFUNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:13:34 -0500
Date: Wed, 6 Feb 2008 15:12:23 -0500
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, tglx@linutronix.de, mingo@redhat.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
Message-ID: <20080206201223.GA25183@hmsendeavour.rdu.redhat.com>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206194040.GA11886@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206194040.GA11886@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 02:40:40PM -0500, Vivek Goyal wrote:
> On Wed, Feb 06, 2008 at 02:25:55PM -0500, Neil Horman wrote:
> > Hey all-
> > 	A hang on kdump was reported to me awhile back, only when systems died
> > via nmi watchdog panic.  The hang wouldn't always be in the same place, but it
> > would usually be somewhere down in purgatory.  In looking at the code, it
> > occured to me that since, during an nmi interrupt, we won't be able to handle
> > additional interrupts, that we won't be able to halt the other processors on a
> > system like we try to do in machine_crash_shutdown.  As such, it appears that
> > leaving the other cpus running exposes us to the risk that another processor
> > will encounter an error and halt the system while we are trying to boot the
> > kdump kernel, and that can result in a hang.  I wrote the attached patch to end
> > the nmi interrupt prior to calling crash_kexec from within die_nmi, and testing
> > here has proven successfull.
> > 
> 
> Hi Neil,
> 
> Why wouldn't I be able to stop other cpus if I am inside an NMI handler? I
> just need to send an NMI IPI to other cpus and they should be able to
> receive and handle it?
> 
> Thanks
> Vivek
> 
Can an APIC accept an NMI while already handling an NMI?  I didn't think they
would interrupt one another, but rather, pend until such time as the previous
NMI was cleared
Neil

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
