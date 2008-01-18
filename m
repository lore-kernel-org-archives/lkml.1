Return-Path: <linux-kernel-owner+w=401wt.eu-S1764620AbYARRhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764620AbYARRhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763802AbYARRhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:37:38 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:1163 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764390AbYARRhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:37:35 -0500
Date: Fri, 18 Jan 2008 18:37:22 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118173722.GC61848@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org> <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:02:44PM -0800, David Schwartz wrote:
> 3) It is most useful for 'kfree' to be non-const because destroying an
> object through a const pointer can easily be done in error. One of the
> reasons you provide a const pointer is because you need the function you
> pass the pointer to not to modify the object. Since this is an unusual
> operation that could be an error, it is logical to force the person doing it
> to clearly indicate that he knows the pointer is const and that he knows it
> is right anyway.

Freeing a const pointer is not and has never been unusual.  It happens
all the time for objects whose lifecycle is "initialise at the start,
readonly afterwards", of which names, in particular in the form of
strings, are a large subset.  It also happens in cases of late
deletion on refcounted objects, when the main owner (the one who is
allowed to change the object and has the non-const pointer) has
dropped its reference, but some object needs a readonly instance a
little longer.  Think virtual files in proc, sysfs or friends kept
open after the underlying information source, often a device, is gone.

  OG.
