Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYCNASd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYCNASd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbYCNASX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:18:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:4391 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbYCNASW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O9Xiyau6+63Cv9oVSUUpmx1X1Uigna3F3vjBm4SNZSyAav1O9CHhzPEiWr2R6prmBtk9rmVgIhztOn7CAJTnsWfeJaWaY34Sshgqh93GxvGc/e0+5u0okGUci4YP4fLZTBXvkV1R6GCHLaOneNPMMoEKO8AfKG5N+wprhJTHnmY=
Date: Fri, 14 Mar 2008 02:54:33 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       avorontsov@ru.mvista.com
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Message-ID: <20080313235433.GA28010@zarina>
Reply-To: cbouatmailru@gmail.com
References: <200803131549.54632.david-b@pacbell.net> <20080313160039.b69a5d24.akpm@linux-foundation.org> <200803131618.58516.david-b@pacbell.net> <20080313162803.ab8bfd4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080313162803.ab8bfd4c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 04:28:03PM -0700, Andrew Morton wrote:
> On Thu, 13 Mar 2008 15:18:58 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > On Thursday 13 March 2008, Andrew Morton wrote:
> > 
> > > hm.  I suppose that if someone want a huge number of GPIOs then we can
> > > convert this to a bitmap or an IDR tree easily enough.
> > 
> > Actually, I tried IDRs for a while and they broke platforms
> > which needed to initialize and use GPIOs early: before kmalloc
> > would work.  A real PITA that was -- and slow too.
> 
> If IDRs were slow, that linear search will be glacial.

Heh.. FWIW, I didn't notice any slowness of that linear search.

I didn't bother to try anything more complicated than linear search
for mere 256 GPIOs. I doubt that IDRs will pour out into any
measurable win even for something like 1024 GPIOs.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
