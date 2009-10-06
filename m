Return-Path: <linux-kernel-owner+w=401wt.eu-S1751056AbZJFEFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbZJFEFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZJFEFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:05:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58306 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZJFEFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:05:47 -0400
Date: Mon, 5 Oct 2009 21:05:26 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pidns memory leak
Message-ID: <20091006040526.GA22923@us.ibm.com>
References: <4AC5F198.2070407@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC5F198.2070407@fr.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
> Hi,
>
> I am facing a problem with the pid namespace when I launch the following  
> lxc commands:
>
> lxc-execute -n foo sleep 3600 &
> ls -al /proc/$(pidof lxc-init)/exe && lxc-stop -n foo
>
> All the processes related to the container are killed, but there is  
> still a refcount on the pid_namespace which is never released.

Thanks for the bug report.

Did you notice any leak in 'struct pids' also or just the pid_namespace ?
If the pids are not leaking, this may be slightly different from the problem
Catalin Marinas ran into:

	http://lkml.org/lkml/2009/7/29/406

And the pid_namespace does not seem to reproduce for me, with out the
'ls -al /proc/...' above, or with the simpler 'ns_exec' approach to
creating pid namespace.

I am going through the code for lxc-execute, but does it remount /proc 
in the container ?

Sukadev
