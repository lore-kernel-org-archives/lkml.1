Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZIBGHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZIBGHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 02:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZIBGHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 02:07:54 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:55288 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbZIBGHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 02:07:54 -0400
Date: Wed, 2 Sep 2009 08:07:43 +0200
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
Message-ID: <20090902060743.GA15101@chram.org>
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9DF3E9.9090309@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Hancock:
> It's most likely a bug in the IDE code somewhere, but realistically the 
> most effective course of action would likely be to switch from the old IDE 
> drivers and use libata instead. The IDE code doesn't receive that much 
> testing these days, and it's really hard to debug (as you've seen, the 
> debugging output is rather atrocious).

Sure, but we're talking a production machine here.  Moving to libata to
handle the IDE drives would involve many changes everywhere in the system
and cause instability.  For instance, /etc/fstab would need to refer to
/dev/sd*, /etc/mdadm.conf needs rewriting as well...  This is a complex move,
and there's no assurance that libata won't have bugs in its PATA handling.

Since the machine is otherwise stable, I'm rather aiming at a workaround.
Today, the workaround I have is to not run SMART long tests but it proved
dangerous.  Therefore, I'm looking for a kernel workaround to avoid the
lockups.

Why would the reading of the status register of the IDE interface cause a
lockup?  If I can prevent the lockup and resume work, I would not mind having
a few lost interrupts events now and then.

Raphael
