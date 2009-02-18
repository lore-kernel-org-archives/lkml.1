Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZBRPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZBRPGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZBRPGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:06:03 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:42443 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZBRPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:06:00 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
Date: Wed, 18 Feb 2009 10:05:24 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr>
In-Reply-To: <499BB76C.1030109@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181005.24952.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 02:23:24 am etienne wrote:
> ... anyway, I think the cleanest way would be to, well, sort smk_netlbladdr
> by mask on insertion (perf doesn't matter  here) and this way
> smack_host_label can stop the loop on first match. Plus, it would give a
> nicer /smack/netlabel ouptut :)

Agreed.

> so, how should we handle it? apply the patches (with whitespaces damages
> corrected ;) )  now (as it corrects a bug) an elaborate the cleaner way
> later?

Well, since you have some time and willingness to do things "the right way" I 
would recommend dropping these patches (which are really just band-aids) and 
working on the right solution to stored the addresses/masks in a sorted list 
with the mask already applied.

FWIW, the NetLabel code (net/netlabel) has to do very similar things with 
sorted address lists so I built an address list construct which builds on the 
list.h ideas and operates in a similar way.  You may find it helpful.

> I think this should go to stable too?

I would worry about getting the patches developed, tested and in an acceptable 
form first, then we can worry about where they should be applied ;)

-- 
paul moore
linux @ hp

