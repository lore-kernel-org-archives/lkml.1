Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXJaMLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXJaMLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXJaMLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:11:46 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:47764 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXJaMLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:11:46 -0400
Date: Wed, 31 Oct 2007 05:11:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m & CONFIG_VIDEO_SAA7146_VV=y
In-Reply-To: <20071026073736.GA24172@elte.hu>
Message-ID: <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
References: <20071026073736.GA24172@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Ingo Molnar wrote:
> the attached config (generated via make randconfig) fails to build due
> to the combination of these config entries:
>
>   CONFIG_VIDEO_DEV=m
>   CONFIG_VIDEO_SAA7146_VV=y
>
> i found no obvious Kconfig way to force VIDEO_SAA7146_VV to be modular
> when VIDEO_DEV is modular - is there a good solution for this?

I guess you didn't like my reply to your first message about this?

http://lkml.org/lkml/2007/10/7/145

kbuild support for modules used as libraries is really poor.  The only way
to do is use select on the library module, and then have all the
dependencies of the selectee be included in the selector, which must be
done recursively so that any modules selected by the selectee have their
dependencies added to the selector.
