Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbZKRVjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbZKRVjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZKRVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:39:36 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59709 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZKRVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:39:36 -0500
MIME-Version: 1.0
In-Reply-To: <20091118213526.GB16630@srcf.ucam.org>
References: <1258474180.16176.62.camel@localhost.localdomain> 
	<ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> 
	<20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> 
	<20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> 
	<20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> 
	<ac3eb2510911181329v26c334a3oab9c554ec64ad0d5@mail.gmail.com> 
	<20091118213526.GB16630@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 18 Nov 2009 22:39:26 +0100
Message-ID: <ac3eb2510911181339q616c56f7rd31b93caed0286c5@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 22:35, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Nov 18, 2009 at 10:29:23PM +0100, Kay Sievers wrote:
>
>> I guess, the "idle_since" file could be made poll()able, and throw an
>> event when the idle time is re-set to 0, so the value checking needs
>> only to happen as long we wait for the disk to become idle. As long as
>> it's busy anyway, the rare wakeups should not matter much. :)
>
> That'd be a userspace wakeup every time something gets submitted to the
> block device, which sounds far from ideal...

No, you would only poll() when you reached the timeout and the disk
entered the idle state. This can not happen more frequently than the
timeout itself.

Kay
