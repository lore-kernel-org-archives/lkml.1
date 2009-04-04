Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZDDESg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZDDESg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 00:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZDDEST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 00:18:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57697 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZDDESS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 00:18:18 -0400
Date: Sat, 4 Apr 2009 05:18:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       corentincj@iksaif.net, Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via the input layer
Message-ID: <20090404041813.GA30746@srcf.ucam.org>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504BBE2828%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 06:57:50PM +0100, Darren Salt wrote:
> This maps the brightness control events to one of two keys, either
> KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP, as needed.
> 
> Some mapping has to be done due to the fact that the BIOS reports them as
> <base value> + <current brightness index>; the selection is done according to
> the sign of the change in brightness (if this is 0, no keypress is reported).
> 
> (Ref. http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-April/002001.html)
> 
> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

The reason I didn't do this is that the Eee changes the input brightness 
in hardware, which means reporting it via the input layer as well can 
cause a single keypress to raise the brightness by two steps - one in 
hardware and one triggered by userland's response to the key press. I'd 
be a little bit wary of this causing problems.

On the other hand, the default behaviour of the acpi video driver is to 
change the brightness itself and then also to send the even to 
userspace, so I guess if it was going to break things it probably would 
have done already...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
