Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYDLFSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYDLFSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYDLFSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:18:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbYDLFSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:18:31 -0400
Date: Fri, 11 Apr 2008 22:18:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
Message-Id: <20080411221817.0b1eb414.akpm@linux-foundation.org>
In-Reply-To: <47FFDBFF.1030809@gmail.com>
References: <12053582234100-git-send-email-yorksun@freescale.com>
	<12053582231281-git-send-email-yorksun@freescale.com>
	<47D8572C.8090501@gmail.com>
	<47FFDBFF.1030809@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 23:45:35 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 03/12/2008 11:20 PM, Jiri Slaby wrote:
> > On 03/12/2008 10:43 PM, York Sun wrote:
> >> +static int fsl_diu_open(struct fb_info *info, int user)
> >> +{
> >> +    struct mfb_info *mfbi = info->par;
> >> +    int res = 0;
> >> +
> >> +    spin_lock(&diu_lock);
> >> +    mfbi->count++;
> >> +    if (mfbi->count == 1) {
> >> +        DPRINTK("open plane index %d\n", mfbi->index);
> >> +        fsl_diu_check_var(&info->var, info);
> >> +        fsl_diu_set_par(info);
> > 
> > Please retest your code (at least) with sleep-inside spinlock debug 
> > option. If I see correctly you call GFP_KERNEL allocation somewhere 
> > deeper in this function, which might sleep.
> > 
>
> ...
>
> ping.
> 
> Seeing this in -mm yet. Are those comments all wrong? Are you working on it?
> 

(top-posting repaired)

Thanks.  I've made a note that this patch has outstanding issues.  Usually
this means that I'll defer merging it until they have been addressed:
either by fixing them or by successfully arguing against the objections.  
