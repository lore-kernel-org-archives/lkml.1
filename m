Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbYBGX2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbYBGX2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbYBGX2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:28:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbYBGX2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:28:42 -0500
Message-ID: <47AB9416.2030508@redhat.com>
Date: Thu, 07 Feb 2008 18:28:22 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user	space
References: <20080205075137.617012701A8@magilla.localdomain>	<20080205080149.GA16929@elte.hu>	<20080205081506.655CB2701A8@magilla.localdomain>	<47AB6652.3010600@redhat.com> <20080207203032.5BF392701AB@magilla.localdomain>
In-Reply-To: <20080207203032.5BF392701AB@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2008 03:30 PM, Roland McGrath wrote:
>> Did you test without CONFIG_PARAVIRT, and CONFIG_PARAVIRT booted both with and
>> without the "noreplace-paravirt" parameter?
> 
> I did not test CONFIG_PARAVIRT at all.  I just fixed what its introduction
> had done to break generic x86-64.
> 
> 

It looks you may have broken paravirt (if even that case worked) because
the iret is actually at the iret_label you removed (after the instruction
is patched.) And most likely neither version worked with "noreplace-paravirt',
because then the iret instruction is out-of-line and the INTERRUPT_RETURN
jumps to it.


