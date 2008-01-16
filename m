Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYAPL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYAPL6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYAPL6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:58:11 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:41445
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYAPL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:58:11 -0500
To: "rae l" <crquan@gmail.com>
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, open-iscsi@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC on MODULE SUPPORT] hello, Rusty, Should we provide module information even if the kernel module compiled built-in with bzImage?
References: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Wed, 16 Jan 2008 12:58:09 +0100
In-Reply-To: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com> (rae l.'s message of "Wed\, 16 Jan 2008 18\:02\:22 +0800")
Message-ID: <87fxwyhtim.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

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

your userspace program is somewhat broken
the userspace should not expect to find the version number in
/sys/module, as this is used by the Linux kernel module subsystem. You
should provide the required information in another way such as a
/proc/ file (bad) or a /sys file (better, but no module stuff, this
has no business with it).

-- 
Mathieu
