Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZKBEpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZKBEpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZKBEpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:45:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbZKBEpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:45:32 -0500
Message-ID: <4AEE63E2.9010003@redhat.com>
Date: Sun, 01 Nov 2009 23:45:22 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: loody <miloody@gmail.com>
CC: linux-kernel@vger.kernel.org, Kernel Newbies <kernelnewbies@nl.linux.org>
Subject: Re: why kernel implement "udelay" by cpu instructions?
References: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com>
In-Reply-To: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 10:13 PM, loody wrote:
> Dear all:
> I find the kernel use cpu instruction to implement the udelay function
> as keeping decrease a big counter by 1.
>
> If I search the right place in kernel, why kernel does so?

Because udelay is used in places where the kernel cannot
use other mechanisms, eg. because interrupts are blocked
or the current process cannot be scheduled out.

> the precision will be different if cpu runs faster or slower, right?

At bootup the kernel measures the delay loop speed of
each CPU.  CPU frequency scaling might make the loop
run slower at times, but that is okay because udelay
simply specifies a *minimum* delay.

This is true even on systems without frequency scaling,
because the udelay loop could be interrupted by an
interrupt, an NMI or by having the CPU trap into SMM
mode and execute code there.

-- 
All rights reversed.
