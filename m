Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZDNGLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZDNGLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZDNGLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:11:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49768 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbZDNGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:11:07 -0400
Date: Tue, 14 Apr 2009 07:12:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Scheduling while atomic in tty code with cdc-acm driver, kernel
 2.6.29.1
Message-ID: <20090414071204.2450b6a0@lxorguk.ukuu.org.uk>
In-Reply-To: <200904140150.10790.oliver@neukum.org>
References: <20090413193633.33ce0710@dhcp-100-2-144.bos.redhat.com>
	<200904140150.10790.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 01:50:10 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Dienstag 14 April 2009 01:36:33 schrieb Chuck Ebbert:
> > BUG: sleeping function called from invalid context at kernel/mutex.c:88
> > in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
> > Pid: 0, comm: swapper Not tainted 2.6.29.1-54.fc11.x86_64 #1
> 
> Is this specific to 2.6.29.1? It looks like setting low_latency, as cdc-acm,
> does for legacy reasons, is harmful now. Please remove these lines:

The only thing that has changed is that this incorrect behaviour (setting
low_latency and doing a flip_buffer_push() in IRQ context) now causes a
warn rather than random failure.

The hack setting of it for high data rate devices was obsolete when the
tty buffer changes went in so it can definitely go in those cases.
