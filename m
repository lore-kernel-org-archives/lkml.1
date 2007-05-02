Return-Path: <linux-kernel-owner+w=401wt.eu-S2993026AbXEBKrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993026AbXEBKrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXEBKrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:47:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:45195 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbXEBKrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:47:01 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] [24/30] x86_64: Shut up warnings for vfat compat ioctls on other file systems
Date: Wed, 2 May 2007 12:46:50 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070501557.815359000@suse.de> <20070501035822.B3FC613CAF@wotan.suse.de> <463760B0.8020705@redhat.com>
In-Reply-To: <463760B0.8020705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021246.51039.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 17:45:52 Chuck Ebbert wrote:
> Andi Kleen wrote:
> > vfat implements compat handlers for these ioctls, but when they
> > were executed on other file systems the kernel would still complain
> > about an unknown compat ioctl.  Just declare them as compatible
> > and let them be rejected when not needed by the normal path.
> > 
> > This makes wine runs a lot quieter
> 
> Does this also restore the original -ENOTTY return code?
> 
> The change that made it return -EINVAL broke a few Wine apps.

No it's still EINVAL as before. I just eliminated the printks.

I guess one could add a IGNORE_IOCTL_ENOTTY() or somesuch though if it's 
really a problem.

-Andi

