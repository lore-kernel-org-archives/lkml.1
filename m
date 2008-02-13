Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYBMNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYBMNeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYBMNdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:33:55 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:42629 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYBMNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=EIhH9O1iyYU+i5hHl1AKxM2lXQGXwgYWrZj6f6y662Y3zrvToQe/aoBqOgIwiDPORvlqnlObLoDpjhCX5CzzjdoXblamdvIUjuRxqoKx801ZNKfLATI5edHWrCg2LDHt5dDPe95gU3uaMZZbtNfhkifYmHDOOdFGWgh0VZaml6o=
Date: Wed, 13 Feb 2008 07:32:42 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk
Subject: Re: latest list of unused Kconfig variables
Message-ID: <20080213073242.5c069c25@zod.rchland.ibm.com>
In-Reply-To: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 03:56:34 -0500 (EST)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> 
>   now that 2.6.25-rc1 is out, i can start updating the output from my
> scanning scripts.  the first updated output is the list of currently
> unused Kconfig variables -- variables that are defined in some Kconfig
> file somewhere but appear to be entirely unused throughout the source
> tree.
> 
>   latest output here, sorted by architecture:
> 
> http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables
> 
> as always, there will probably be some false positives for one reason
> or another.
> 
>   output from the other scanning scripts will be up in short order.

You have lots of false positives (or something) for arch/powerpc.  Seems
your script picked up #define names and comments that happen to match a
Kconfig variable?  And you have false positives on several CPU
variables, as they are used within Kconfig files themselves to select
different sets of options.

For arch/ppc, the WANT_EARLY_SERIAL stuff was added by Al to fix those
boards that unconditionally called early_serial_setup by selecting
SERIAL_8250 in commit f08243a491f3e21feabbb04476a03fb0cbc975ff.  Al,
couldn't we just select SERIAL_8250 right in the board config
instead?  

Of course, arch/ppc is dying soon-ish anyway so we might not even
bother.

josh
