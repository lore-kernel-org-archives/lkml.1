Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbYBOUdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbYBOUdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYBOUdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:33:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:60671 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbYBOUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:33:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ekJHyjP25OElP5n3/60Mw96vjaMNwo0+VIBkXKdHlMDo/wpE2hAz+dRD4bgCXbk0u
	SLTTZeJIqWkm7a8XjD8LA==
Date: Fri, 15 Feb 2008 12:32:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802151229150.25583@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <20080214040918.d735e920.pj@sgi.com>
 <alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com> <20080215032748.8b07e5eb.pj@sgi.com> <alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, David Rientjes wrote:

> It would be possible to do all of this in both sys_set_mempolicy() and 
> sys_mbind() by masking off the set of possible modes and checking the 
> result for being >= MPOL_MAX:
> 
> 	if ((mode & MPOL_MODE_FLAGS) >= MPOL_MAX)
> 		return -EINVAL;

Actually, in sys_setmempolicy() or sys_mbind() where mode is an int:

	unsigned short flags;

	flags = mode & MPOL_MODE_FLAGS;
	mode &= ~MPOL_MODE_FLAGS;
	if (mode < 0 || mode >= MPOL_MAX)
		return -EINVAL;
