Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZKOIjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZKOIjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZKOIjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:39:15 -0500
Received: from lo.gmane.org ([80.91.229.12]:33127 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZKOIjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:39:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Raja R Harinath <harinath@hurrynot.org>
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Sun, 15 Nov 2009 13:15:02 +0530
Message-ID: <87y6m8s03l.fsf@hariville.hurrynot.org>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
	<4AFCC06B.1030302@schaufler-ca.com>
	<19857.1258147396@turing-police.cc.vt.edu>
	<4AFE1EA9.60102@schaufler-ca.com>
	<hdl92e$srv$1@taverner.cs.berkeley.edu>
	<1258170491.16857.142.camel@Joe-Laptop.home>
	<4AFE3C53.70709@schaufler-ca.com>
	<1258176381.16857.155.camel@Joe-Laptop.home>
	<4AFE5A20.20608@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.92.163.37
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Cancel-Lock: sha1:OUZ1XB++ZTD1ptbEllxbmzqcx8M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Casey Schaufler <casey@schaufler-ca.com> writes:

> Joe Perches wrote:
[snip]
>> I assert that code should be made as readable
>> as possible and that the code used fit the
>> reader's expectations.
>>
>> strcmp(foo, "BAR") is natural.
>> strncmp(foo, "BAR", sizeof("BAR")) is unnatural
>> and should not be used.
>
> Oh good gravy. I've been writing C code since the 1970's and
> have seen enough "unnatural" code to make most people think that
> PASCAL was a good idea. This is not unnatural code. This is an
> argument over which side of the head of the pin the odd angel
> should dance on. Give it up. You're advocating a gratuitous
> change. Can't y'all go find some questionable casts to expunge?
> That might actually be useful.

I think the point is that

    strncmp(foo, "BAR", sizeof("BAR"))

is exceedingly similar to

    strncmp(foo, "BAR", strlen("BAR"))

which mean different things.  The point of this series was the suspicion
that people who intended the "strlen" variant might have used the
"sizeof" variant.

And, since this confusion exists, it is probably better to use two
canonical forms for the two different meanings

   strcmp(foo, "BAR")
   strncmp(foo, "BAR", strlen("BAR"))

and avoid other equivalent formulations.

- Hari

