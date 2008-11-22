Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYKVRbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYKVRbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbYKVRb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:31:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50014 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbYKVRb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:31:28 -0500
Date: Sat, 22 Nov 2008 10:29:52 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       katzj@redhat.com
Subject: Re: linux-next: rr tree build failure
Message-Id: <20081122102952.50ec43ce.zaitcev@redhat.com>
In-Reply-To: <20081122064132.GA6196@suse.de>
References: <20081121141913.90d05091.sfr@canb.auug.org.au>
	<200811212128.52317.rusty@rustcorp.com.au>
	<20081121183403.GC16353@suse.de>
	<200811221301.07058.rusty@rustcorp.com.au>
	<20081122064132.GA6196@suse.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 22:41:32 -0800, Greg KH <gregkh@suse.de> wrote:

> > FYI, if Pete had discovered this __setup issue today, the correct fix would
> > be:
> > 1) core_param(nousb) for backwards compat.
> > 2) module_param(disable) for modern users who want module/in-built symmetry
> >    (ie. boot cmdline "usbcore.disable", and "modprobe usbcore disable")

> Is there a real reason why we need to change this at all?

As far as I know, in Fedora "nousb" is never used as a module parameter.
It came about because interrupt tables are sometimes bad and once
a request_irq() is done in an HCD, there's an interrupt storm. So,
the "nousb" is mostly used in the SysLinux's command line, rarely
in the real command line, and never in /etc/modprobe.conf.
I'm adding Jeremy to cc: for confirmation.

I think it would be good to try and drop "nousb" option in Fedora 11.
The conflict with "nousbstorage" would resolve itself too if we do.

-- Pete
