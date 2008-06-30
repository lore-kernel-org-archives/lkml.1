Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYF3Rfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYF3Rfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYF3Rfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:35:47 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57119 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYF3Rfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:35:46 -0400
Date: Mon, 30 Jun 2008 13:35:35 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@qumranet.com>,
       =?utf-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080630173535.GB4877@fieldses.org>
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <486704AC.2090207@qumranet.com> <48671A12.90205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48671A12.90205@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 10:13:54PM -0700, Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>>>
>>> Yes, it's intended behaviour.  Filesystem IO syscalls are considered  
>>> "fast" and are interruptible.  Usermode code can reasonably expect  
>>> that file IO will never return EINTR.
>>
>> That's filesystem dependent; if you mount an nfs filesystem with the  
>> 'intr' mount option, it will be interruptible (which makes sense, as  
>> it is impossible to guarantee the server's responsiveness).
>
> 'intr' is a pretty bad idea, and I would never recommend it ('soft' is  
> better).

Yipes.

> It's an excellent way to destroy data when a stray signal  
> causes a syscall to fail with EINTR in an unexpected way (write being  
> the obvious one, but link, unlink, truncate or even close can fail in  
> odd ways can cause havok).

And with "soft" all that can happen with the need for the stray
signal....

I suppose the relative likelihoods of hitting the problem under "soft"
and "intr" may vary depending on the details of your setup.  But in
general I'd've thought it'd be easier to control stray signals than,
say, stray network problems.

--b.

> I don't know of any other filesystem with a similarly bad option.
