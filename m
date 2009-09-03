Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbZICWgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbZICWgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbZICWf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:35:59 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:43720 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbZICWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:35:59 -0400
Date: Fri, 4 Sep 2009 00:36:03 +0200
From: Bastian Blank <waldi@debian.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       544145@bugs.debian.org, Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
Message-ID: <20090903223603.GA19945@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com, 544145@bugs.debian.org,
	Keir Fraser <keir.fraser@eu.citrix.com>
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org> <4AA03DE8.40706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AA03DE8.40706@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 03:06:32PM -0700, Jeremy Fitzhardinge wrote:
> On 09/03/09 15:02, Bastian Blank wrote:
> > AFAIK only AMD support the syscall instruction, so yes it is an AMD
> > machine. And yes, disabling the only thing that make the glibc call this
> > instruction works around it.
> The bug actually appears to be in xen_sysret32, ie the crash happens on
> the way out of the kernel.

This function looks weird. It tries to restores the user code segment.
But the documentation from AMD explicitely stat that the CS and SS are
restored from the STAR register.

Bastian

-- 
Killing is stupid; useless!
		-- McCoy, "A Private Little War", stardate 4211.8
