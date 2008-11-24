Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYKXWvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYKXWvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYKXWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:51:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:6189 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYKXWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=vuna6x0RFT8ITbhWYsNNbTW8dMXxEx8P8/gKHmH4ABykVRnIZt7Ht2aWpFCD7Tz1bR
         /IJQBcb0u+BDtQph3x39xJvHm1NDytZlvk/daxWBtI+YTGNHxQ8vID+OWL1IGT1dg0w9
         Uw4Pzdo6kbU9SAGBF3Po9yFTEuJuj2SC2fVJ8=
Date: Mon, 24 Nov 2008 23:51:39 +0100
To: Mel Gorman <mel@csn.ul.ie>, bzolnier@gmail.com
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081124225139.GA26953@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Mel Gorman <mel@csn.ul.ie>,
	bzolnier@gmail.com, sshtylyov@ru.mvista.com,
	alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <20081124155632.GE23190@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124155632.GE23190@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 24, 2008 at 03:56:32PM +0000, Mel Gorman wrote:
> Hi,
> 
> I got caught by commit 20df429dd6671804999493baf2952f82582869fa as I didn't
> immediately guess that "ide_generic." was necessary on the kernel command line
> when compiled in instead of as a module. While it didn't catch me for long,
> my concern is that this is going to trip up other people with old machines
> that need that mask.  This change was introduced in 2.6.28-rc1 but I didn't
> catch it till now as I hadn't used the laptop in a while.
> 
> I have a few questions on the commit.
> 
> 1. Why was it necessary to disable the legacy probes like this at all?
> Would it be possible to try the probe_mask in the event nothing is found
> or does that have other consequences?

take a look at 0cbccbc30a60ff60dbeb203154f1f527c632de9b for background
info on the decision behind the probe_mask. Now ide-generic probes only
the legacy ports as is the case in common machine configurations and
is a sort-of fall-back option in case there's no PCI IDE controller
present. In addition, the Kconfig text explains more why ide-generic
should not be used in modern systems (not sharing IRQs, preventing
controller-specific drivers from attaching in certain cases).

And the probing _is_ done when loaded as a module so the problem is
not with the mask - in your case the probing will work just fine as
you need ide0 and ide1, AFAICT. The problem is that the probing is not
being done when ide-generic is compiled in and is the only controller
driver enabled. The only trick I can think of off the top of my head
is a Kconfig-option enabling ide-generic only when no other controller
driver is enabled and getting rid of the possibility of compiling it as
a module.

Bart, I'm sure you have a better idea :).

-- 
Regards/Gruss,
    Boris.
