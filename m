Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYLEE1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYLEE1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYLEE1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:27:32 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:46598 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYLEE1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OW8NrmNSsePxyxUxM+lhKF23uHCC10e9fIMv6Fxd+VMo8XDQHneloPLXCeFbsqu3pc
         Fa8DY+H+zm3mGrhFDIQacmh5ggrJIyeQQU1HZKQxO/L6x6oyPdpYA+yQcnEjS6x+yq94
         v6osLyOF5va07bXbHFYv6bK2dQNcWhnu6Wqfg=
Message-ID: <21d7e9970812042027w13271ceas91ecab87aa60562e@mail.gmail.com>
Date: Fri, 5 Dec 2008 14:27:29 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?C=E9dric_Godin?=" <cedric@belbone.be>
Subject: Re: Xorg crash at first start
Cc: "Keith Packard" <keithp@keithp.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4937E87C.6030106@belbone.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4937E87C.6030106@belbone.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 12:26 AM, Cédric Godin <cedric@belbone.be> wrote:
> Hello,
>
> With the v2.6.28-rc7-105-gfeaf384 kernel, when booting my compaq with
> attached config, the screen switches in graphical mode but then switches
> back in textual mode with an 'irq10 nobody cared' error in dmesg (attached).
>
> If I restart kdm by hand, all is ok (i have my kdm) but the error yet
> appears in dmesg (at each X start in fact).
>
> I bisected the problem (git bisect log attached) and found the following
> commit as "culprit" :
>
> commit 52440211dcdc52c0b757f8b34d122e11b12cdd50
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Nov 18 09:30:25 2008 -0800
>
>    drm: move drm vblank initialization/cleanup to driver load/unload
>
>    drm vblank initialization keeps track of the changes in driver-supplied
>    frame counts across vt switch and mode setting, but only if you let
> it by
>    not tearing down the drm vblank structure.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> Reverting it brings back my X screen at first start.

Just for testing, can you try without using vesafb....

so remove the vga= line from the commandline or build the kernel
without vesafb support.

Dave.
