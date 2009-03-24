Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZCXMVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZCXMVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZCXMVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:21:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:48780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZCXMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:21:37 -0400
Subject: Re: [PATCH] perf_counter: fix perf_poll()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1237897096.24918.181.camel@twins>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
	 <1237875063.7530.11.camel@marge.simson.net>
	 <1237875580.7827.3.camel@marge.simson.net>
	 <1237877884.8754.2.camel@marge.simson.net>
	 <18888.38308.223722.602357@cargo.ozlabs.ibm.com>
	 <1237888224.24918.159.camel@twins>
	 <1237891863.13862.27.camel@marge.simson.net>
	 <1237892368.24918.160.camel@twins>  <1237897096.24918.181.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Mar 2009 13:21:19 +0100
Message-Id: <1237897279.24918.182.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 13:18 +0100, Peter Zijlstra wrote:
> The below does seem to fix things (along with the previous kerneltop.c
> patch),.. however now kerneltop is going splat like:
> 
> # ./kerneltop -e 1:2 -c 10
> KernelTop refresh period: 2 seconds
> ret: 1
>  left: 0000000080200000
>    ip: 000000008038d4ad
> right: 00000000ffffffff
> kerneltop: kerneltop.c:985: record_ip: Assertion `left <= ip && ip <= right' failed.
> Aborted
> 
> Which isn't making much sense..

Seems to be an artefact of running a 32bit kerneltop on a 64bit kernel..
freshyl compiled 64bit kerneltop works just fine.
