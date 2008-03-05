Return-Path: <linux-kernel-owner+w=401wt.eu-S935266AbYCEARr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935266AbYCEARr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764033AbYCEAQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:16:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:47617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057AbYCEAQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:16:52 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: preempt bug in set_pmd_pfn?
Date: Wed, 5 Mar 2008 01:16:45 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47CDBB87.8090906@goop.org> <200803050106.31609.ak@suse.de> <47CDE42F.8080400@goop.org>
In-Reply-To: <47CDE42F.8080400@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050116.46119.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 01:07:11 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >> Won't this leave a stale tlb on the old processor?
> >>     
> >
> > __set_fixmap should be only used in early boot, so it's always
> > on CPU 0
> 
> vdso32-setup.c:map_compat_vdso() uses it to create the compat vdso 
> mapping, which typically happens on the first execve(),

First execve for 32bit binaries?

Anyways __set_fixmap is __init and at the first  execve (unless you have initramfs) 
init.text should be already freed.

-Andi
