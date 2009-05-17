Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZEQPC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZEQPC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZEQPCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:02:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48129 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZEQPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:02:45 -0400
To: Andrea <andrea256it@yahoo.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: super root shell/mode/api
From: Andi Kleen <andi@firstfloor.org>
References: <861928.62033.qm@web23602.mail.ird.yahoo.com>
Date: Sun, 17 May 2009 17:02:40 +0200
In-Reply-To: <861928.62033.qm@web23602.mail.ird.yahoo.com> (Andrea's message of "Sun, 17 May 2009 13:06:53 +0000 (GMT)")
Message-ID: <87iqjzpyb3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea <andrea256it@yahoo.it> writes:
>
> I know there is an OOM handling, but the only thing that
> happened was the hard disk light flashing for more or less 30 minutes
> and I was forced to press the reset button and my data was lost :(

One trick I found very useful to make OOM much less painful is to
make the swap partition small (not zero though).

The traditional suggestion of 2x RAM is far too large on modern
systems and since Linux is rather inefficient at swapping having
so much swap space just prolongs the death struggle.

With a smaller swap partition (not more than 100-200MB) the OOM killer kicks in 
relatively quickly when something goes wrong and kills the offending process.

> I think it would be simply awesome to have a Linux Kernel mode
> similar to the c-64 cartridge concept.
>
> Maybe call it in honor to the c-64 'cartridge freeze mode' or so :)
>
> You hit a button combination and you enter in a Linux Kernel ncurses menu
> and/or shell and/or GUI, where you can for example:

You could do all that today by using a suitable kexec/kdump kernel setup with
sysrq-C. 

The kdump kernel can do all that based on the image of the previous kernel.
Some of it is very easy (e.g. for disassemble just run "crash"), other
parts don't make sense (e.g. swap out processes -- the parent kernel
already did that)

Traditional distributions just dump the image, but there's no
principle reason it couldn't do more.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
