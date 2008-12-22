Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYLVK5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYLVK5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYLVK5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:57:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57436 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYLVK5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:57:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 0/6][v3] Container-init signal semantics
References: <20081221005106.GA4912@us.ibm.com>
Date: Mon, 22 Dec 2008 02:55:48 -0800
In-Reply-To: <20081221005106.GA4912@us.ibm.com> (Sukadev Bhattiprolu's message
	of "Sat, 20 Dec 2008 16:51:06 -0800")
Message-ID: <m1wsds5vij.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> This patchset implements the design/simplified semantics suggested by
> Oleg Nesterov.  The simplified semantics for container-init are:
>
> 	- container-init must never be terminated by a signal from a
> 	  descendant process.
>
> 	- container-init must never be immune to SIGKILL from an ancestor
> 	  namespace (so a process in parent namespace must always be able
> 	  to terminate a descendant container).
>
> 	- container-init may be immune to unhandled fatal signals (like
> 	  SIGUSR1) even if they are from ancestor namespace (SIGKILL is
> 	  the only reliable signal from ancestor namespace).

It sounds you are still struggling to get something that works and gets
done what needs to be done.  So let me suggest a simplified semantic that
should be easier to implement and test, and solves the biggest problem
that we must solve in the kernel.

- container-init ignores SIGKILL and SIGSTOP.

- container-init is responsible for setting the rest of the signals
  to SIG_IGN.

If that isn't enough for all of the init's we can go back and
solve more in kernel land.  That simplified semantic is certainly
enough for sysvinit.

> Limitations/side-effects of current design
>
> 	- Container-init is immune to suicide - kill(getpid(), SIGKILL) is
> 	  ignored. Use exit() :-)

That sounds like correct behavior.

Eric
