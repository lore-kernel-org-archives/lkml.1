Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZGVPgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZGVPgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZGVPgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:36:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52351 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZGVPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:36:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:cc:subject:references:from:date:in-reply-to:message-id:
	user-agent:mime-version:content-type:x-system-of-record;
	b=tS092LPjCmV+wevS5RMKAxFcyDkhJU6yHQ8kt6liPSFq/ly57fKP+5Wyl5e8u+n/B
	6XYGwTo9FeHt/X+ujMSbw==
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl>
	<20090720151008.GC10015@suse.de>
	<alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
	<alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
	<alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
	<alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>
	<alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>
	<alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
	<alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
	<alpine.LFD.2.00.0907212211040.4630@troy-laptop>
	<alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
	<alpine.LNX.1.10.0907221340540.26357@bizon.gios.gov.pl>
From: Ian Lance Taylor <iant@google.com>
Date: Wed, 22 Jul 2009 08:36:21 -0700
In-Reply-To: <alpine.LNX.1.10.0907221340540.26357@bizon.gios.gov.pl> (Krzysztof Oledzki's message of "Wed\, 22 Jul 2009 13\:49\:58 +0200 \(CEST\)")
Message-ID: <m3k520buh6.fsf@google.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Oledzki <olel@ans.pl> writes:

> BTW: here is a simple testcase for this bug:
>
> --- fno-strict-overflow-fixed-bug.c ---
> #include <stdio.h>
>
> int main() {
>
>         unsigned char i;
>
>         for (i = 0; i < 128; i++)
>                 printf("loop %u\n", i);
>
>         return 0;
> }
> --- cut here ---

I can confirm that this is broken in gcc 4.2 using -fno-strict-overflow,
and works correctly in gcc 4.3 and later.  Sigh.

Ian
