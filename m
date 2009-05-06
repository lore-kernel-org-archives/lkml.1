Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbZEFQwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbZEFQwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZEFQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:52:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZEFQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:52:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC PATCH 1/3] add generic hypercall support
Date: Wed, 6 May 2009 18:52:15 +0200
User-Agent: KMail/1.9.9
Cc: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, avi@redhat.com
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A019614.9080702@codemonkey.ws> <4A01A9C5.5010601@novell.com>
In-Reply-To: <4A01A9C5.5010601@novell.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905061852.15931.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19EPDl2DXClE04QtRfrLOAu0vl0qQV+NVM17wW
 7GDtlJvSo7b1n/sLBu7705D8hj0nbTj5Pm6vVxKrPZ+M8UFWB/
 2wA4OdCL83I7pjBQ2/4gQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 May 2009, Gregory Haskins wrote:
 
> Ok, so we would
> need to come up with these pio_calls for x86, and no other arch can use
> the infrastructure (but wait, PPC can use PCI too, so how does that
> work? It must be either MMIO emulation or its not supported?  That puts
> us back to square one).

PowerPC already has an abstraction for PIO and MMIO because certain
broken hardware chips don't do what they should, see
arch/powerpc/platforms/cell/io-workarounds.c for the only current user.
If you need to, you could do the same on x86 (or generalize the code),
but please don't add another level of indirection on top of this.

	Arnd <><
