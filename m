Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbZEGUnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbZEGUnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763380AbZEGUm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:42:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763346AbZEGUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:42:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Date: Thu, 7 May 2009 22:42:48 +0200
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <200905072200.22007.arnd@arndb.de> <4A03451E.9020304@gmail.com>
In-Reply-To: <4A03451E.9020304@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072242.49316.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/O7TOBG181ycU+s9YapbehTOr3f0gcHh7xx/
 gJnykHrF3FysZy9g77iJD3+856twQFRcopcY7KHQ6WIR099roB
 aPfwcT4dpHJOPoCTv3o3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Gregory Haskins wrote:
> Arnd Bergmann wrote:
> > An mmio that goes through a PF is a bug, it's certainly broken on
> > a number of platforms, so performance should not be an issue there.
> >   
> 
> This may be my own ignorance, but I thought a VMEXIT of type "PF" was
> how MMIO worked in VT/SVM. 

You are right that all MMIOs (and PIO on most non-x86 architectures)
are handled this way in the end. What I meant was that an MMIO that
traps because of a simple pointer dereference as in __raw_writel
is a bug, while any actual writel() call could be diverted to
do an hcall and therefore not cause a PF once the infrastructure
is there.

> I guess the problem that was later pointed out is that we cannot discern
> which devices might be pass-through and therefore should not be
> revectored through a HC.  But I am even less knowledgeable about how
> pass-through works than I am about the MMIO traps, so I might be
> completely off here.

An easy way to deal with the pass-through case might be to actually use
__raw_writel there. In guest-to-guest communication, the two sides are
known to have the same endianess (I assume) and you can still add the
appropriate smp_mb() and such into the code.

	Arnd <><
