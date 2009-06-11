Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbZFKPAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbZFKPAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZFKPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:00:46 -0400
Received: from NaN.false.org ([208.75.86.248]:58544 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbZFKPAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:00:45 -0400
X-Greylist: delayed 2022 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 11:00:45 EDT
Date: Thu, 11 Jun 2009 10:27:00 -0400
From: Daniel Jacobowitz <dan@debian.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Nicolas Pitre <nico@cam.org>,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: ERESTART_RESTARTBLOCK and ptrace()
Message-ID: <20090611142700.GA12259@caradoc.them.org>
Mail-Followup-To: "Kirill A. Shutemov" <kirill@shutemov.name>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Nicolas Pitre <nico@cam.org>, linux-kernel@vger.kernel.org,
	linux@arm.linux.org.uk
References: <cc557aab0906100325o4fd55e0eveb958915214809e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc557aab0906100325o4fd55e0eveb958915214809e3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2008-05-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 01:25:34PM +0300, Kirill A. Shutemov wrote:
> I've got bug in handling ERESTART_RESTARTBLOCK. Kernel version is 2.6.28.
> 
> Steps to reproduce:
> 1. Attach using ptrace() to process while it's in a syscall which use
> ERESTART_RESTARTBLOCK
> on interrupt. The easiest way is to attach to process which is in nanosleep().
> 2. Run a syscall in context of the process like it does gdb.
> 3. Continue the process.
> 
> Results:
> Syscall(nanosleep) return error code 516(ERESTART_RESTARTBLOCK). It's
> kernel's internal error
> code and should never appear at userspace.
> 
> It seems ARM-related since I can't reproduce it on x86.

That's because GDB has code to do the right thing on x86.  Consider
filing a GDB bug please.

-- 
Daniel Jacobowitz
CodeSourcery
