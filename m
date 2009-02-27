Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbZB0BTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbZB0BTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZB0BSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:18:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41285 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZB0BSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:18:54 -0500
Date: Thu, 26 Feb 2009 22:22:22 -0300
From: Glauber Costa <glommer@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] remove static declaration from wall clock version
Message-ID: <20090227012222.GA5979@poweredge.glommer>
References: <1235677340-3139-1-git-send-email-glommer@redhat.com> <200902262050.27555.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902262050.27555.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 08:50:26PM +0100, Arnd Bergmann wrote:
> On Thursday 26 February 2009, Glauber Costa wrote:
> > @@ -548,15 +548,13 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >  
> >  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
> >  {
> > -       static int version;
> > +       int version = 1;
> >         struct pvclock_wall_clock wc;
> >         struct timespec now, sys, boot;
> >  
> >         if (!wall_clock)
> >                 return;
> >  
> > -       version++;
> > -
> >         kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
> >  
> >         /*
> 
> Doesn't this mean that kvm_write_guest now writes an uninitialized value
> to the guest?
No. If you look closely, it's now initialized to 1.

> 
> I think what you need here is a 'static atomic_t version;' so you can
> do an atomic_inc instead of the ++.

I don't see the need for atomicity. This is just called once, at boot time.
The only thing we're protecting here is one guest from another. The stack
will do fine for this.
