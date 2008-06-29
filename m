Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYF2HqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYF2HqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYF2Hp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:45:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:15968 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYF2Hp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QwBf3AszXcYOb4+n2yf4UM2au/ibtVjHV1yEoZpcugibH7GZL0ooFanwmE2yeaenuo
         0ufKc75n+WHN8pHWXCoV2lYXuuA9kHwa+htAkPREVBDd+Pt9Tx623qu49hxRA2NnpthB
         Q7OA+4gHB1n4k024PbsaEMO2HUXO0RSdiNH/U=
Message-ID: <48673DAE.6050905@gmail.com>
Date: Sun, 29 Jun 2008 10:45:50 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@qumranet.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <486704AC.2090207@qumranet.com> <48671A12.90205@goop.org> <48671FF6.1070501@qumranet.com> <48672ADE.1090300@goop.org>
In-Reply-To: <48672ADE.1090300@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>> Applications should not assume that write() (or other syscalls) can't
>> return EINTR.  Not all filesystems have a bounded-time backing store.
>
> The distinction between 'fast' (filesystem) and 'slow' (terminals and
> pipes) blocking syscalls goes back to the earliest days of Unix, and
> is part of the ABI.  Most filesystem syscalls are not documented to
> ever return EINTR.

POSIX documents EINTR for write(), and the manpage on my Linux distro
says the same.
However I don't think introducing EINTR would be beneficial (it will
likely cause applications that don't expect it to break).

>
>> 'soft' has its own problems; namely false positives when someone
>> steps on the network cable, temporarily blocking packet flow, or when
>> using a clustered server which may take some time to recover from a
>> fault.
>
> Sure.  It's the basic problem of trying to make network access
> transparent by hiding the failure modes.  You either need to put up
> with spurious timeouts caused by transient failures, or unbounded
> blocking on real failures.
>
> Regardless, NFS is the exception here, and making normal block-backed
> filesystems start throwing EINTRs around would be a huge behavioural
> change.

Agreed.

Best regards,
--Edwin
