Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZASCK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZASCK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZASCKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:10:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36473 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbZASCKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:10:13 -0500
Date: Mon, 19 Jan 2009 11:09:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
Message-Id: <20090119110906.58ccbcbd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090117202638.GA11825@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009 12:26:38 -0800
Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:

> 
> Container-init must behave like global-init to processes within the
> container and hence it must be immune to unhandled fatal signals from
> within the container (i.e SIG_DFL signals that terminate the process).
> 
> But the same container-init must behave like a normal process to 
> processes in ancestor namespaces and so if it receives the same fatal
> signal from a process in ancestor namespace, the signal must be
> processed.
> 
> Implementing these semantics requires that send_signal() determine pid
> namespace of the sender but since signals can originate from workqueues/
> interrupt-handlers, determining pid namespace of sender may not always
> be possible or safe.
> 

Is this feature is for blocking signals from children to name-space
creator(owner) ? And automatically used when namespace/cgroup is created ?
IOW, Container-init is Namespace-Cgroup-init ? 

I'm glad if you add some documentation updates about how-it-works to patch set.

Thanks,
-Kame


