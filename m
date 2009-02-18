Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZBRTTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZBRTTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbZBRTTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:19:10 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27982 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZBRTTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:19:08 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
Date: Wed, 18 Feb 2009 14:18:35 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902181005.24952.paul.moore@hp.com> <499C5377.8050408@numericable.fr>
In-Reply-To: <499C5377.8050408@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181418.35622.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 01:29:11 pm etienne wrote:
> OK, I'm about to send a new patch; but while testing my patches and reading
> code, I noticed another bug :
>
> In smackfs.c:smk_write_netlbladdr
> the netmask mask.s_addr is not handled correctly, the netmask should be :
> 1- computed in u32
> 2- converted to be32 !!
> with current code, a "pseudo u32 mask" is applied to a be32 ipaddr; it
> occurs to works for "common netmasks" (multiple of 8), not for
> "intermediate" mask (/15, /25)

Heh, back when Casey was first drafting this code I mentioned the same issue 
regarding byte ordering but Casey assured me that everything was correct.  I 
didn't have a Smack test system at the time so I couldn't verify the behavior.  
I'm glad you had a chance to test it, needless to say you should fix that when 
you submit your patch.

-- 
paul moore
linux @ hp

