Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZECWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZECWJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZECWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:09:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54066 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZECWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:09:25 -0400
Date: Sun, 3 May 2009 23:09:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Bank screen after resume on Dell XPS M1330
Message-ID: <20090503220923.GA27497@srcf.ucam.org>
References: <200905031111.50789.arvidjaar@mail.ru> <20090503105932.GA18170@srcf.ucam.org> <20090503215740.GG1368@ucw.cz> <20090503215935.GA27257@srcf.ucam.org> <20090503220552.GC20166@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503220552.GC20166@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 12:05:52AM +0200, Pavel Machek wrote:
> On Sun 2009-05-03 22:59:35, Matthew Garrett wrote:
> > Not for current nivida, except for some Thinkpads.
> 
> Ok, that's bad. There still should be chance to reverse-engineer the
> BIOS or tweak the emulation in libx86 until it works with the nvidias,
> but... that's a lot of work.

nvidia BIOSes call into chunks of system BIOS code that aren't available 
after boot. They rewrite themselves so the c000:0003 entry point just 
returns in order to prevent you from executing random code. It's not an 
emulation issue. The only way to fix this is to finish nouveau's 
implementation of the nvidia bios table bytecode and execute the init 
tables on resume.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
