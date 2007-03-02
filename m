Return-Path: <linux-kernel-owner+w=401wt.eu-S2992448AbXCBN6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992448AbXCBN6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992447AbXCBN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:58:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41623 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992440AbXCBN6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:58:20 -0500
Date: Fri, 2 Mar 2007 14:58:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jean Delvare <khali@linux-fr.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070302135810.GF2156@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302114747.GB1212@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-03-02 11:47:47, Matthew Garrett wrote:
> On Fri, Mar 02, 2007 at 12:40:23PM +0100, Pavel Machek wrote:
> 
> > Whitelist seems like a way to go :(.
> 
> The DSDT code clearly can't touch the hardware itself - hardware access 
> is carried out by the kernel. If we can identify cases where ACPI reads 
> and writes would touch resources claimed by other drivers, that would be 
> a good starting point for working out what's going on.
> 
> Of course, this ignores the case where the DSDT just traps into SMM 
> code. That one is clearly unsolvable.

We can't solve SMM stuff. (Whitelist needed :-).

Actually for the acpi stuff... we might wrap ACPI interpretter with a
semaphore that needs to be taken before starting any AML code. Then
just make sure sensors take same semaphore?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
