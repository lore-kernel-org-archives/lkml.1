Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbZJMOps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbZJMOps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760025AbZJMOpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:45:47 -0400
Received: from thunk.org ([69.25.196.29]:55173 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760023AbZJMOpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:45:46 -0400
Date: Tue, 13 Oct 2009 10:45:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?utf-8?B?6aOe6aKc?= <win847@gmail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Greg Ungerer <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Drivers compiled into the kernel can reduce code size
Message-ID: <20091013144504.GC8175@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?utf-8?B?6aOe6aKc?= <win847@gmail.com>,
	Tim Abbott <tabbott@ksplice.com>, Greg Ungerer <gerg@snapgear.com>,
	linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <363172900910122246y2ea4ee69gf133e725b0a54146@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <363172900910122246y2ea4ee69gf133e725b0a54146@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 01:46:18PM +0800, 飞颜 wrote:
> Dear all,
> 
>        I has a question below:
> 
>      Why Drivers compiled into the kernel can reduce code size
> compared with Module ways?
> 
>      Kernel + Driver Module (Code Size) > Kernel(include Driver)

Each loadable kernel module is subject to rounding to 4k pages, where
as when a driver is built into the kernel, its text, data, and BSS
segments can be included into the kernel text, data, and BSS segments. 

Drivers that are compiled into the kernel also can use the same single
huge page TLB entry for the kernel text segment, so using a fewer
kernel modules can also result in fewer TLB misses.

       	       	   	       	  	    - Ted
