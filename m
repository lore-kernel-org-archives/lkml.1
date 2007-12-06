Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbXLFVLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbXLFVLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXLFVLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:11:12 -0500
Received: from gw.goop.org ([64.81.55.164]:35590 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbXLFVLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:11:11 -0500
Message-ID: <4758656B.1000301@goop.org>
Date: Thu, 06 Dec 2007 13:11:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 1/9] remove volatile keyword from clflush.
References: 20071204204931.GC32018@elte.hu <1196867313972-git-send-email-gcosta@redhat.com> <1196867319253-git-send-email-gcosta@redhat.com>
In-Reply-To: <1196867319253-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> the p parameter is an explicit memory reference, and is
> enough to prevent gcc to being nasty here. The volatile
> seems completely not needed.
>   

The usual reason for these types of "volatiles" is to make type checking
happier, since "volatile void *" is compatible with any argument you
might pass.  IOW, if you pass a plain "char *" then the compiler will
promote it to "volatile char *" and not complain, and passing an already
volatile pointer will be OK too.

The volatile isn't there to modify the generated code in any way.

    J
