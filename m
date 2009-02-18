Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZBRS3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZBRS3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBRS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:29:15 -0500
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:48536 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZBRS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:29:14 -0500
Message-ID: <499C5377.8050408@numericable.fr>
Date: Wed, 18 Feb 2009 19:29:11 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>, Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com>
In-Reply-To: <200902181005.24952.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

Paul Moore wrote:
..
> Well, since you have some time and willingness to do things "the right way" I 
> would recommend dropping these patches (which are really just band-aids) and 
> working on the right solution to stored the addresses/masks in a sorted list 
> with the mask already applied.
> 
OK, I'm about to send a new patch; but while testing my patches and reading code, I noticed another bug : 

In smackfs.c:smk_write_netlbladdr
the netmask mask.s_addr is not handled correctly, the netmask should be :
1- computed in u32
2- converted to be32 !!
with current code, a "pseudo u32 mask" is applied to a be32 ipaddr; it occurs to works for "common netmasks" (multiple of 8), not for "intermediate" mask (/15, /25)


> FWIW, the NetLabel code (net/netlabel) has to do very similar things with 
> sorted address lists so I built an address list construct which builds on the 
> list.h ideas and operates in a similar way.  You may find it helpful.
> 
OK, I tested some code in userspace and when i was confident enough coded it to kernel

>> I think this should go to stable too?
> 
> I would worry about getting the patches developed, tested and in an acceptable 
> form first, then we can worry about where they should be applied ;)
> 

OK :)
