Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYF2GZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYF2GZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 02:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYF2GZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 02:25:39 -0400
Received: from gw.goop.org ([64.81.55.164]:37614 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbYF2GZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 02:25:39 -0400
Message-ID: <48672ADE.1090300@goop.org>
Date: Sat, 28 Jun 2008 23:25:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <486704AC.2090207@qumranet.com> <48671A12.90205@goop.org> <48671FF6.1070501@qumranet.com>
In-Reply-To: <48671FF6.1070501@qumranet.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Applications should not assume that write() (or other syscalls) can't 
> return EINTR.  Not all filesystems have a bounded-time backing store.

The distinction between 'fast' (filesystem) and 'slow' (terminals and 
pipes) blocking syscalls goes back to the earliest days of Unix, and is 
part of the ABI.  Most filesystem syscalls are not documented to ever 
return EINTR.

> 'soft' has its own problems; namely false positives when someone steps 
> on the network cable, temporarily blocking packet flow, or when using 
> a clustered server which may take some time to recover from a fault.

Sure.  It's the basic problem of trying to make network access 
transparent by hiding the failure modes.  You either need to put up with 
spurious timeouts caused by transient failures, or unbounded blocking on 
real failures.

Regardless, NFS is the exception here, and making normal block-backed 
filesystems start throwing EINTRs around would be a huge behavioural change.

    J
