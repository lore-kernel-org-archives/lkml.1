Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZGVNzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZGVNzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZGVNze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:55:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:53498 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZGVNze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:55:34 -0400
Date: Wed, 22 Jul 2009 23:53:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH -v2 1/2] VM/SELinux: require CAP_SYS_RAWIO for all
 mmap_zero operations
In-Reply-To: <20090721230339.20180.99803.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0907222345530.17486@tundra.namei.org>
References: <20090721230339.20180.99803.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Eric Paris wrote:

>  	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
>  	if (error)
>  		return error;
> +
> +	if ((addr < mmap_min_addr) && !capable(CAP_SYS_RAWIO))
> +		return -EACCES;
> +

These DAC checks should happen before the LSM hook, in keeping with the 
general design goal of LSM of "DAC before MAC", so that application 
behavior remains as consistent as possible.


- James
-- 
James Morris
<jmorris@namei.org>
