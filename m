Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZERBy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZERBy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZERBys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:54:48 -0400
Received: from claw.goop.org ([74.207.240.146]:44027 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZERByr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:54:47 -0400
Message-ID: <4A10BFE8.9020703@goop.org>
Date: Sun, 17 May 2009 18:54:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: devzero@web.de
CC: david@lang.hm, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Where do we stand with the Xen patches?
References: <720427516@web.de>
In-Reply-To: <720427516@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> or is maintaining two different kernel packages a problem?
>   

Yes, distros hate the proliferation of kernel packages with different 
config options, partly because of the combinatorial explosion (32 vs 64, 
UP vs SMP, PAE vs non-PAE...).  An explicit design intent of all the Xen 
work is that it can be compile-time enabled without any (significant) 
effect on native performance, so that the decision to enable Xen doesn't 
have any downsides (either in terms of raw performance or maintenance of 
the kernel package).

> if so, instead of using IFDEF`s, can`t the critical path`s being generously circumvented 
> by default, (if, else...), needing some dom0 kernel bootparam to be activated (i.e. use
> the kernel as dom0 kernel) ?
>   
Well, broadly speaking, yes.  We try to avoid putting if/thens in 
critical paths, and where there are changes to hot patches, we use 
dynamic code patching to make it as efficient as possible.

    J
