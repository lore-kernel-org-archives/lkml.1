Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbXJMPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbXJMPu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXJMPuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 11:50:18 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:9966 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbXJMPuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 11:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=fnsTsfEG7qE1JVFyldfW5/Z+bmcUJqgOkdbgdaMf7lebhu4JMo/RfCRDCFIc8LE9bA37wR+6Ur8B7HYjBYjnBV7HJfsre8VbZUJZulBUKtim3voAj1nofAHLtYR8OzvrEaYgAJhAbEccchBWFl8bdxiPz9g+kzMdMx9Q0GjeD94=
Date: Sat, 13 Oct 2007 11:50:10 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Domen Puncer <domen.puncer@telargo.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Message-ID: <20071013155010.GA11864@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/


Domen Puncer's change to support "MPC5200 low power mode" (in
powerpc-git, which is in Linus's tree now) adds new code calling
mpc52xx_pm_prepare and _finish with suspend_state_t as an argument,
while Rafael Wysocki's pm-rework-struct-platform_suspend_ops.patch
converts those to take no arguments.  So the build fails:


arch/powerpc/platforms/52xx/mpc52xx_pm.c:61: error: conflicting types
for ‘mpc52xx_pm_prepare’

include/asm/mpc52xx.h:270: error: previous declaration of
‘mpc52xx_pm_prepare’ was here

arch/powerpc/platforms/52xx/mpc52xx_pm.c:167: error: conflicting types
for ‘mpc52xx_pm_finish’

include/asm/mpc52xx.h:272: error: previous declaration of
‘mpc52xx_pm_finish’ was here


Sorting this out is beyond my abilities; I don't know how to deal with
stuff like this (in arch/powerpc/platforms/52xx/lite5200_pm.c):

static int lite5200_pm_prepare(suspend_state_t state)
{
	/* deep sleep? let mpc52xx code handle that */
	if (state == PM_SUSPEND_STANDBY)
	       return mpc52xx_pm_prepare(state);

Patch authors CC'd.

--
Joseph Fannin
jfannin@gmail.com
