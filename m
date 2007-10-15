Return-Path: <linux-kernel-owner+w=401wt.eu-S933597AbXJOS1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbXJOS1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764880AbXJOS1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:27:41 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:51290 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760179AbXJOS1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:27:40 -0400
Date: Mon, 15 Oct 2007 11:27:39 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, pexu@kapsi.fi,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [build bug] error: 'VID_HARDWARE_GEMTEK' undeclared
In-Reply-To: <20071015111345.GA26777@elte.hu>
Message-ID: <Pine.LNX.4.58.0710151117260.15624@shell4.speakeasy.net>
References: <20071015111345.GA26777@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Ingo Molnar wrote:
> randconfig testing of latest -git found this build bug:
>
> drivers/media/radio/radio-gemtek.c:557: error: 'VID_HARDWARE_GEMTEK' undeclared here (not in a function)
>
> config attached.

Problem:
# CONFIG_VIDEO_V4L1_COMPAT is not set

The VID_HARDWARE_* defines are only created if that is turned on.  gemtek
should depend on VIDEO_V4L1_COMPAT.

*or*

As far as I can tell, these VID_HARDWARE defines are entirely useless.  I
couldn't find any instance of them being used for anything other than setting
the .hardware field of struct video_device, and I was unable to find any
instance of that field being used.

It looks like the whole thing is just unused cruft.  Mauro, would it be ok if
I made a patch to just delete the whole mess?
