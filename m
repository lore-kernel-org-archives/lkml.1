Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZGaRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZGaRAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZGaRAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:00:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47392 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556AbZGaRAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:00:30 -0400
Date: Fri, 31 Jul 2009 18:01:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, charles.f.johnson@intel.com
Subject: Re: [PATCH] Revsion 2 of the security processor kernel driver;
Message-ID: <20090731180130.3660b71a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090724002439.GC26267@kroah.com>
References: <1248388211-13881-1-git-send-email-mark.a.allyn@intel.com>
	<20090724002439.GC26267@kroah.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 17:24:39 -0700
Greg KH <greg@kroah.com> wrote:

> On Thu, Jul 23, 2009 at 03:30:11PM -0700, Mark Allyn wrote:
> >  For the upstream community, this is revision 2. Changes are the
> >  relocation of this driver to the staging area.
> > 
> >  This is the Linux kernel driver for the Security Processor, which is
> >  a hardware device the provides cryptographic, secure storage, and
> >  key management services. 
> > 
> >  Please be aware that this patch does not contain any encryption
> >  algorithm. It only transports data to and from user space 
> >  applications to the security processor.
> > 
> >  Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> 
> Can you provide me a TODO file that lists what is remaining to be done
> to this driver in order to get it accepted into the main portion of the
> kernel tree?

My guesses would be something like

- Fix firmware loading
- Get firmware into firmware git tree
- Review and tidy each algorithm function
- Check whether it can be plugged into any of the kernel crypto API
  interfaces
- Do something about the magic shared memory interface and replace it
  with something saner (in Linux terms)

The last one is non-trivial. The other security processors we have
support for also have fairly disgusting interfaces as do most of the user
space crypto library plugins. It doesn't seem to be something that
structures nicely (eg see the zSystem crypto driver we have now).

We may thus have to simply accept "Less ugly" unless anyone can point me
at a clean, well designed crypto processor API we could use.

Alan
