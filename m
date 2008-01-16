Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYAPM7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYAPM7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYAPM7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:59:48 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38716 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYAPM7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:59:48 -0500
Date: Wed, 16 Jan 2008 13:59:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: rae l <crquan@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, open-iscsi@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC on MODULE SUPPORT] hello, Rusty, Should we provide module information even if the kernel module compiled built-in with bzImage?
Message-ID: <20080116125953.GA27176@uranus.ravnborg.org>
References: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 06:02:22PM +0800, rae l wrote:
> hello, Rusty:
> I encountered a problem when modules compiled built-in with bzImage:
> 
> open-iscsi is an iSCSI software, it has a userspace daemon(iscsid) and
> a userspace mani tool(iscsiadm) and a kernel module
> (scsi_transport_iscsi),
> recently the kernel module has been accepted into the official kernel
> release; since the module licensed with GPL, it could be compiled as
> built-in,
> 
> but when I compiled the module within the bzImage, the problem appeared:
> 
> tux ~ # iscsid -f
> iscsid: Missing or Invalid version from
> /sys/module/scsi_transport_iscsi/version. Make sure a up to date
> scsi_transport_iscsi module is loaded and a up todate version of
> iscsid is running. Exiting...
> 
> this is just because iscsid hope there's an external module could be
> under /sys/module, and read the kernel module's version information,
> but if the module compiled built-in, all its module information
> discarded and it doesn't appeared under /sys/module/, that would break
> iscsid.
> 
> Now the problem is:
> 
> Should we provide module information under
> /sys/module/<module-name>/... even if the module compiled built-in
> with bzImage?
> Or just this module(scsi_transport_iscsi) should be marked with [M] only?
> 
> if the former solution is preferred, I would be happy to work on
> MODULE_INFO-like macros improvements with CONFIG_MODULE undefined.

I recall Magnus Damm did something in this respect.
Try to google a bit and see if you hit something that
can be used as inspiration.

I was maybe only for module parameters (autoparm was the name I think).

It is not a perfect fit but maybe a help.

	Sam
