Return-Path: <linux-kernel-owner+w=401wt.eu-S1763305AbZEGUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305AbZEGUz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZEGUzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:55:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54539 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZEGUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:55:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Date: Thu, 7 May 2009 22:54:06 +0200
User-Agent: KMail/1.9.9
Cc: Chris Wright <chrisw@sous-sol.org>, Gregory Haskins <ghaskins@novell.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <4A031471.7000406@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org> <4A033685.7070802@gmail.com>
In-Reply-To: <4A033685.7070802@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072254.06982.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/lCFrZJ40LW3Q57JTC/KAZQEQizCuwszGEMRx
 sfiH5dKNzMNOFBnAto/JupGwcXALkYR/f/+tpd2Xc6q+P43gBp
 FAWSg9BGt1J8wTNGVX3+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Gregory Haskins wrote:
> What I am not clear on is how you would know to flag the address to
> begin with.

pci_iomap could look at the bus device that the PCI function sits on.
If it detects a PCI bridge that has a certain property (config space
setting, vendor/device ID, ...), it assumes that the device itself
will be emulated and it should set the address flag for IO_COND.

This implies that all pass-through devices need to be on a different
PCI bridge from the emulated devices, which should be fairly
straightforward to enforce.

	Arnd <><
