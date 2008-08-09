Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYHIGhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYHIGhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 02:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYHIGhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 02:37:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYHIGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 02:37:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Date: Sat, 9 Aug 2008 08:37:07 +0200
User-Agent: KMail/1.9.9
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel> <200808090039.20289.arnd@arndb.de> <1218242614.19082.65.camel@nimitz>
In-Reply-To: <1218242614.19082.65.camel@nimitz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090837.07417.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nfSRRjiKLtyP332W25pGw3UQIopQrMVHjg2F
 T4s6CL4GQgv/0M8LgSeN/EPQs8njeduO6VEd7Pz8tcUmxhFkmM
 mUOz2WFY9hdeXshG/RB5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Dave Hansen wrote:
> On Sat, 2008-08-09 at 00:39 +0200, Arnd Bergmann wrote:
> > The main problem I see with that would be atomicity: If you want multiple
> > processes to keep interacting with each other, you need to save them at
> > the same point in time, which gets harder as you split your interface into
> > more than a single file descriptor.
> 
> It could take ages to write out a checkpoint even to a single fd, so I
> suspect we'd have the exact same kinds of issues either way.

I guess either way, you have to SIGSTOP (or similar) all the tasks you want
to checkpoint atomically before you start saving the contents.
If you use a single fd, you can do that under the covers, when using a 
more complex file system, it seems more logical to require an explicit
interface for this.

	Arnd <><
