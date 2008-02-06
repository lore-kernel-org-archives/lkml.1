Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYBFVFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYBFVFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759823AbYBFVFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:05:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759816AbYBFVFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:05:14 -0500
Date: Wed, 6 Feb 2008 16:04:07 -0500
From: Neil Horman <nhorman@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Horman <nhorman@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, tglx@linutronix.de,
       mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
Message-ID: <20080206210407.GB25183@hmsendeavour.rdu.redhat.com>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206194040.GA11886@redhat.com> <20080206201223.GA25183@hmsendeavour.rdu.redhat.com> <47AA16CA.6000003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AA16CA.6000003@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 12:21:30PM -0800, H. Peter Anvin wrote:
> Neil Horman wrote:
> >Can an APIC accept an NMI while already handling an NMI?  I didn't think 
> >they
> >would interrupt one another, but rather, pend until such time as the 
> >previous
> >NMI was cleared
> 
> The CPU certainly won't (there is a hidden flag that's cleared on IRET 
> which disables NMI; it's possible to re-enable NMI by executing a dummy 
> IRET inside the NMI handler.)
> 
> 	-hpa

So that would be another solution I would expect.  Would you rather I
investigate that, or is the proposed solution more reasonable?

Neil


-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
