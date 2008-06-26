Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYFZQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYFZQF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYFZQFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:05:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYFZQFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:05:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 58/60] microblaze_v4: sys_microblaze.c
Date: Thu, 26 Jun 2008 18:04:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-58-git-send-email-monstr@seznam.cz> <1214483429-32360-59-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-59-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806261804.25344.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+RNkgsBbc1VxxXmKGCoItfxlyD5RRzWqwEf9t
 PnSqRlkoOwlcyaVsa4z/rMvgsiqcaLsuqt6wG0w3abjls6l6jn
 8GqRrG7qRhkESSwRCT7Zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:
> +
> +int sys_uname(struct old_utsname *name)
> +{
> +       int err = -EFAULT;
> +
> +       down_read(&uts_sem);
> +       if (name && !copy_to_user(name, utsname(), sizeof(*name)))
> +               err = 0;
> +       up_read(&uts_sem);
> +       return err;
> +}

This actually seems to be dead code, as your sys_call_table only contains
sys_newuname but not sys_uname.

	Arnd <><
