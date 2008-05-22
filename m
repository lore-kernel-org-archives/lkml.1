Return-Path: <linux-kernel-owner+w=401wt.eu-S935006AbYEVLzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935006AbYEVLzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbYEVLyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:54:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63921 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495AbYEVLyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:54:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: BUG: Ecryptfs ioctl handling
Date: Thu, 22 May 2008 13:53:44 +0200
User-Agent: KMail/1.9.9
Cc: mahalcro@us.ibm.com, linux-kernel@vger.kernel.org
References: <20080522111746.6c78507b@core>
In-Reply-To: <20080522111746.6c78507b@core>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221353.45239.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/CO1Hwpo8VIi6cbRweG1R59vpUhnr/KmcbEpJ
 AzukRIHGxU8uSySizhJDsLMTEivNYhQRG+X8xt2DcKe47c8dmU
 Pfa8G0e3bmqLqgDq9rkhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Alan Cox wrote:
> 
> Ecryptfs has an ioctl method that checks for the underlying fs ioctl
> method and can call down into. Unfortunately however it doesn't check for
> an underlying unlocked_ioctl method and call that if present.
> 
> Notices while removing the remaining users of ->ioctl from my dev tree.
> 
> Really ecryptfs needs its own ->unlocked_ioctl op to call into either
> unlocked ioctl below or lock_kernel/ioctl/unlock_kernel below.

Similarly, ecryptfs doesn't provide a ->compat_ioctl op that calls into
the file system's ->compat_ioctl operation if present.
This will be needed to make ioctl handling work on file systems that
rely on ->compat_ioctl for 32 bit processes.

I wonder if there are other places in the kernel that just pass down
ioctl calls to a slave file system or driver and need to have this
added.

	Arnd <><
