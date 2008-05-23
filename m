Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYEWLCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYEWLCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbYEWLBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:01:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45703 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752959AbYEWLBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:01:52 -0400
Date: Fri, 23 May 2008 11:46:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Push ioctl BKL down into the i2c code
Message-ID: <20080523114639.1705de71@core>
In-Reply-To: <20080523093545.175c769c@hyperion.delvare>
References: <20080522222327.1af72794@core>
	<20080523093545.175c769c@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 09:35:45 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Alan,
> 
> On Thu, 22 May 2008 22:23:27 +0100, Alan Cox wrote:
> > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> 
> Description of what the patch does and why it is needed, please. I
> can't apply it without that. My first impression is a patch making the
> code bigger and more complex with no obvious benefit ;)

It pushes the BKL down into the i2c driver. The intention is to remove
the big kernel lock ioctl method from the file_operations structure so
that we can work on getting rid of the big kernel lock for good. It's one
of a series of patches that give me an x86-32 tree with no ->ioctl method
at all.

Similar activity is going on for the other calls made under the BKL the
goal being to push it down into drivers and then eliminate it.

