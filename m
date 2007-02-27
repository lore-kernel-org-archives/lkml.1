Return-Path: <linux-kernel-owner+w=401wt.eu-S1751343AbXB0BgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbXB0BgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXB0BgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:36:18 -0500
Received: from gw.goop.org ([64.81.55.164]:60322 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbXB0BgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:36:18 -0500
Message-ID: <45E38B01.2010509@goop.org>
Date: Mon, 26 Feb 2007 17:36:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Use para_fill instead of vmi_get_function for APIC ops
References: <45E37617.6050107@codemonkey.ws> <45E37EB5.7070100@vmware.com>
In-Reply-To: <45E37EB5.7070100@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Patch looks good, thanks.   But the whole para_fill / vmi_get_function
> stuff could probably be done even cleaner.  It was just a helper at
> first to work around the awkward syntax, and it is still a bit ugly,
> but I haven't come up with a better solution yet, mostly because with
> the new inlining work Jeremy is doing, we might want to start doing
> selective inlining, in which case I'll have to go back over the code
> anyway to clean everything to get the logic right in all cases.

Yes, my patching updates make pretty much all the pv_ops patchable,
including the apic ones.  The simple thing is to fill out paravirt_ops
with the appropriate pointers, then set the .patch operation to
paravirt_default_patch, which will basically turn them all into direct
calls.  If you want to start inlining stuff, then you can do that too.

    J
