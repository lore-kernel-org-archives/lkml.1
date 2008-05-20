Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYETEZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYETEZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYETEZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:25:05 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:58514 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYETEZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:25:04 -0400
Date: Mon, 19 May 2008 21:25:01 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 1/1] i2c: align i2c_device_id
In-Reply-To: <4831D2F3.6020506@gmail.com>
Message-ID: <Pine.LNX.4.58.0805192105470.6129@shell4.speakeasy.net>
References: <1211203124-3096-1-git-send-email-jirislaby@gmail.com>
 <20080519210003.65b65d14@hyperion.delvare> <4831D2F3.6020506@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Jiri Slaby wrote:
> On 05/19/2008 09:00 PM, Jean Delvare wrote:
> > Thanks for this patch, it's in my i2c tree now and will be sent to
> > Linus by the end of the week. I wasn't aware of this possible alignment
> > issue, sorry.
>
> To be honest, neither I was until I hit it while testing hid bus (where I did
> the same mistake). Thanks.

Is there any more information about this?  Items in a structure should be
aligned to the alignment required by their type.  Usually sizeof(x) ==
alignof(x), but not always.

I guess in this case the structures are used as a cross-platform binary on
disk representation, and so the alignment of the build host must match the
alignment of the target?

Maybe it would be better to include the alignment attribute in the
definition of kernel_ulong_t?
