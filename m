Return-Path: <linux-kernel-owner+w=401wt.eu-S1765454AbXJOTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765454AbXJOTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbXJOTJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:09:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:24731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbXJOTJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XPjKmOoxAncrKA/XcjpbvUt+Jpu31XXwqmxpCJfsVZeKPJNs0XMDd9Dt0FwISIJWQ7xVUkpwqgyXfuhY0q1/wLuZoTddpYVOgGQA13Rm2tFABd22lzOmv4358gGBHkVjtXmjmrRDK3wDOxKG0xU9/1FqlMwVEVqgYf9a/JkkPks=
Message-ID: <4713BAD0.9020606@gmail.com>
Date: Mon, 15 Oct 2007 21:09:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: RocketPort Linux driver errors on module reload
References: <bububu786234897832@pripojeni.net> <87k5pozgb5.fsf@tac.ki.iif.hu>
In-Reply-To: <87k5pozgb5.fsf@tac.ki.iif.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2007 02:57 PM, Ferenc Wagner wrote:
> You are the man, Jiri!  That indeed fixes the problem.
> Thank you very much.  What a turnaround...

You're welcome, that's why we're here.

> Shouldn't Documentation/rocket.txt also be changed?  I'm not sure
> whether that support email is still valid.

And so am I. I wouldn't change it, maybe they will contact you some later ;).

Anyway the driver faces another problem with pci refcounting (it doesn't
increment the counter) and the device might be removed from it any time the pci
bus code decides. Are you willing to test to-pci-probing patches (i.e. patches
which converts the driver to the model introduced in linux 2.4)? If not, I'll
only increment the counter on modprobe and decrement it on rmmod, since it would
be a safe (in the meaning of not changing that much code) way of fixing the problem.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
