Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZFHOah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZFHOah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFHOa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:30:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46208 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZFHOa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:30:29 -0400
Date: Mon, 8 Jun 2009 15:30:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608143023.GA16752@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <200906081539.20459.oliver@neukum.org> <20090608142154.GD14234@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608142154.GD14234@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 04:21:54PM +0200, Ingo Molnar wrote:

> The kernel _needs_ to have precise information about whether a piece 
> of hardware is in use or not.

The kernel can only have that information if userspace tells it. What 
we're quibbling over is whether the kernel should be explicitly told 
about the requirement (ie, every time an app makes a key grab in X the 
kernel gets told about it) or whether it should be implicit (userspace 
knows that a key grab has been made and so requests that the keyboard 
not be suspended).

We *can* put all of that complexity in the kernel. The question is 
whether it buys us anything. We'd have to modify huge chunks of 
userspace and in the process we'd end up limited to whatever policy 
happens to exist in the version of the kernel the user is running.

I'd like the kernel to expose this functionality but leave the policy 
decisions to userland.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
