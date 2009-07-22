Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZGVPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZGVPm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZGVPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:42:55 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60641 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbZGVPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:42:55 -0400
Date: Wed, 22 Jul 2009 11:42:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: James Morris <jmorris@namei.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, spender@grsecurity.net, dwalsh@redhat.com,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH -v2 1/2] VM/SELinux: require CAP_SYS_RAWIO for all
 mmap_zero operations
In-Reply-To: <alpine.LRH.2.00.0907222345530.17486@tundra.namei.org>
Message-ID: <alpine.DEB.1.10.0907221141570.17465@gentwo.org>
References: <20090721230339.20180.99803.stgit@paris.rdu.redhat.com> <alpine.LRH.2.00.0907222345530.17486@tundra.namei.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, James Morris wrote:

> On Tue, 21 Jul 2009, Eric Paris wrote:
>
> >  	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
> >  	if (error)
> >  		return error;
> > +
> > +	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
> > +		return -EACCES;
> > +
>
> These DAC checks should happen before the LSM hook, in keeping with the
> general design goal of LSM of "DAC before MAC", so that application
> behavior remains as consistent as possible.

Could they be moved out of core code? mmap_min_addr is already a strange
feature. Now we adding something on top of it.

