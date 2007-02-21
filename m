Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXBURO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXBURO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422714AbXBUROZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:14:25 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:56334 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422710AbXBUROY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:14:24 -0500
Date: Wed, 21 Feb 2007 18:14:08 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 03/18] Dont leak NT bit into next task
In-Reply-To: <erh57g$oeb$1@sea.gmane.org>
Message-ID: <Pine.LNX.4.61.0702211812480.12039@yvahk01.tjqt.qr>
References: <20070221014413.282048309@mini.kroah.org> <20070221014953.GD3684@kroah.com>
 <erh57g$oeb$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 21 2007 11:00, Giuseppe Bilotta wrote:
>On Wednesday 21 February 2007 02:49, Greg KH wrote:
>
>>  /* frame pointer must be last for get_wchan */
>> -#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
>> -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\n\t"
>> +#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
>> +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
>
>No idea if this is a problem or not, but you forgot a \n after popf.

It is on the edge. RESTORE_CONTEXT will not be passed any 
arguments, so it is the only thing in a single line, and hence
the implicit \n of the source file applies after \t.
But yes, it may be dangerous. Better is an explicit \n or semicolon
after popf.


Jan
-- 
