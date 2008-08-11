Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYHKQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYHKQzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYHKQzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:55:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYHKQzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:55:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Date: Mon, 11 Aug 2008 18:53:13 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
References: <20080807224033.FFB3A2C1@kernel> <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
In-Reply-To: <20080811152201.GB25930@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808111853.13854.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/koEm00te+9HcL58/23mN69PLdlkCeu6EmH1Q
 c1YNNf2cMz1DGdpmhywbGocUxoJ8rpPOHhAz5D9W7Us9hpXiOB
 tpJ0CR6IEEloYxDxfNqew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Serge E. Hallyn wrote:
> At the restart end, every resource which was checkpointed will have to
> be re-created, and permissions checked against the privilege of the
> task which did the restart.  We may end up having to make use of the new
> credentials for this.
> 
> This could become unpleasant: if an unprivileged task asked a privileged
> helper to create something for the unprivileged task to use (i.e. a
> raw socket), then the user needs to be privileged to re-created the
> resource.  But it's necessary.

Right. Of course, the hard part here will be to make it obvious to
be safe. Having to check all sorts of permissions means there will
be many opportunities for exploitable bugs.

The best way I can think of for this would be to use existing syscalls
(e.g. sched_setscheduler, setfsuid, ...) from user space whereever
possible and do only the bare minimum for the restart part in the kernel.

	Arnd <><
