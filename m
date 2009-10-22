Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZJVBMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZJVBMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 21:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZJVBMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 21:12:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48261 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZJVBMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 21:12:41 -0400
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, randy.dunlap@oracle.com,
       rusty@rustcorp.com.au, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
Subject: Re: request_module vs. modprobe blacklist (and security subsystem implications)
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Oct 2009 18:12:38 -0700
In-Reply-To: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com> (Eric Paris's message of "Wed\, 21 Oct 2009 11\:02\:28 -0400")
Message-ID: <m14opss03d.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> I recently added a new LSM hook into __request_module(),
> security_kernel_module_request().  This new hook checks if a process
> should have permission to trigger the loading of a kernel module.  The
> attack vector imagined was that some module (IPX for example) has a
> vulnerability.  An attack program (which doesn't have permission to load
> the IPX module directly) might be able to get the networking stack to
> try to autoload the module.  Once loaded the attack program could then
> use the larger surface area to exploit the kernel.
>
> We have found that many users disable the IPv6 module by setting their
> modprobe config to look like:
>
> blacklist ipv6
> install ipv6 /bin/true

They need to be using /proc/sys/net/ipv6/conf/*/disable_ipv6 instead.
As the above scenario keeps the bonding driver from loading.

Eric
