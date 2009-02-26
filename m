Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZBZTva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZBZTva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZBZTvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:51:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZBZTvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:51:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCH] remove static declaration from wall clock version
Date: Thu, 26 Feb 2009 20:50:26 +0100
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
References: <1235677340-3139-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1235677340-3139-1-git-send-email-glommer@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902262050.27555.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19sP0QlxGXb+fjBIQmUCSxUvRFIbEPNb8uLz/X
 lOikDer7kqqQD+D0agMlD4PyTmLge588m2uSzqWkNomUD5IWbd
 nI0oMaidtVQJuZiRgqn+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Glauber Costa wrote:
> @@ -548,15 +548,13 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  
>  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>  {
> -       static int version;
> +       int version = 1;
>         struct pvclock_wall_clock wc;
>         struct timespec now, sys, boot;
>  
>         if (!wall_clock)
>                 return;
>  
> -       version++;
> -
>         kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
>  
>         /*

Doesn't this mean that kvm_write_guest now writes an uninitialized value
to the guest?

I think what you need here is a 'static atomic_t version;' so you can
do an atomic_inc instead of the ++.

	Arnd <><
