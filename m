Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYAND5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYAND5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYAND5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:57:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:25287 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYAND5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DOivksDvcE+X52VJXDexE5naPZV7RhQX6g9ZpgRBcXSqE7Hq/5ipKUhpmmOmwNFwFhRJRFOx/h1Ds9xpST//wHkQ0EbzZKipEDuOiYBj9BEMIxcYwoaRXLy3I+qvHS5xW0kUNchkzWzgnFT4a3Y5/hpqDMUOQqiEk+vz5xCmvyk=
Message-ID: <75b66ecd0801131957s1e70bda9x342f16a7d16a2789@mail.gmail.com>
Date: Sun, 13 Jan 2008 22:57:13 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Jan Marek" <linux@hazard.jcu.cz>
Subject: Re: Is it possible to change IRQ for certain device?
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080111165711.GA21173@hazard.jcu.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080110110535.GA25706@hazard.jcu.cz>
	 <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
	 <20080111165711.GA21173@hazard.jcu.cz>
X-Google-Sender-Auth: e50f456a23251080
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 11:57 AM, Jan Marek <linux@hazard.jcu.cz> wrote:
> I suppose, that VGA card does not need unique IRQ, but programmers,
> which wrote driver, want it. I can imagine, that VGA card have many
> interrupts, especially in the OpenGL games, but I cannot assign unique
> IRQ for VGA card at all :-(
>
> But thank you for advice: I will try to send e-mail to Gigabyte and ask
> they, if it possible to do change in the BIOS.
>
> BTW: it is interesting: I had a Biostar TA690G motherboard and it behave
> similar as Gigabyte: I cannnot assign unique IRQ to the external
> graphics card... Chipsets of this motherboards are the same...
>
> I've tried to solve this problem by bought of new motherboard: Gigabyte
> MA790FX-DS5. I will see, if this board will behave as previous board...

Why is a shared IRQ a problem for you?  IRQ handlers are supposed to
be fast enough that disabling an IRQ line for the duration of the
handler execution should not be a problem even if the IRQ is shared.
VGA interrupts in particular should only fire once per frame and only
need to flip some bits to wake up any processes waiting on vsync.

If you have issues with a shared VGA interrupt then the bug is that
some IRQ handler runs for too long and should be deferring work to a
bottom half.

Lee
