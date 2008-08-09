Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYHIGoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYHIGoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 02:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYHIGnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 02:43:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYHIGnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 02:43:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
Date: Sat, 9 Aug 2008 08:43:12 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <200808090029.28286.arnd@arndb.de> <489CD0F9.9060603@cs.columbia.edu>
In-Reply-To: <489CD0F9.9060603@cs.columbia.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090843.12922.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+3Js+b4RPoBiZQmTqRyMkV2ZvPduQwh1V+x9q
 4841znjZAgg/pCEJ1A1qcvsfZsYhN6VN4vM8+dUSVp44aBiTFh
 lOHhBB/SyGIgiF+qTmbRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Oren Laadan wrote:
> >> Anyway, either a single structure for both 32 and 64 bit x86, or separate
> >> "struct cr_hdr_cpu{_32,_64}", one for each architecture.
> > 
> > struct pt_regs is part of the kernel ABI, it will not change.
> 
> I'm in favor about keeping the format identical between the variations of
> each architecture. Note, however, that "struct pt_regs" won't do because it
> may change with these variations.
> 
> So we'll take care of the padding and add r8..r15 in the next version.
> 

Fair enough. How about making the layout in that structure identical to
the 64-bit pt_regs though? I don't know if we need that at any time,
but my feeling is that it is nicer than a slightly different random
layout, e.g. if someone wants to extend gdb to look at checkpointed
process dumps.

	Arnd <><
