Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYE1QEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYE1QEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYE1QEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:04:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:49733 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYE1QEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Pz1N/ek35nyoEKcURvoLYa/G84iTiIeH54IWsJ0pvwNo/PAF6RSgA5lFjunFHXAURSIC6xqronvCVOo59gGmUdhfiI93UVk49+cBq8yXg4K4Z3dUFBWft/VLU78kNfJq0dgp2OiFcsQdOzoQcnNfOhVfptJF735K1AG9U+p3TeE=
Date: Wed, 28 May 2008 20:04:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
	of apic_write
Message-ID: <20080528160413.GA6910@cvg>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com> <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, May 28, 2008 at 04:35:14PM +0100]
| On Sat, 24 May 2008, Cyrill Gorcunov wrote:
| 
| > apic_write_around will be expanded to apic_write in 64bit mode
| > anyway. Only a few CPUs (well, old CPUs to be precise) requires
| > such an action. In general it should not hurt and could be cleaned
| > up for apic_write (just in case)
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| 
| Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
| 
|  Almost all local APIC write accesses must use apic_write_around().  The
| notable exceptions are appropriately guarded accesses to the ESR (there is
| no need ever to write to this register on Pentium processors and a read of
| the register has side-effects) and pieces of code known never to run on
| original Pentium processors.
| 
|   Maciej
| 

Thanks Maciej!

Could you take a look please on

http://lkml.org/lkml/2008/5/26/146

i'm investigateting what is happening (Adrian pointed on
main reason I think) but can't understand why is that.

		- Cyrill -
