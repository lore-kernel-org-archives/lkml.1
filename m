Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYC1SDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYC1SDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYC1SDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:03:00 -0400
Received: from gw.goop.org ([64.81.55.164]:33153 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbYC1SDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:03:00 -0400
Message-ID: <47ED32BA.1070008@goop.org>
Date: Fri, 28 Mar 2008 11:02:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, xen-devel@lists.xensource.com
Subject: Re: [PATCH 0/3] xen: Fix oops when mapping/unmapping addr above 1Gb
References: <1206722297-11763-1-git-send-email-markmc@redhat.com>
In-Reply-To: <1206722297-11763-1-git-send-email-markmc@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> Hi,
>         In Fedora rawhide we're currently seeing oopses whenever
> a processes dlopen()s a library which prelink() has previously
> relocated above 1Gb. Some more details at:
>
>   https://bugzilla.redhat.com/436453
>
>         The issue seems to be that during xen_pgd_pin(), we only
> pin PTE pages, but xen's release_pmd() tries to unpin PMD pages
> too.
>
>         The following series of patches is against the latest
> x86 tree.
>   

Hm, OK.  I'm trying to work out what happened here.  I guess its a 
latent bug which is only visible now that its possible to incrementally 
free pmds.

A side note is that I'm planning on pinning pmds in the future, so that 
we can get away replace the full pgd page per mm with a pgd page per cpu.

    J
