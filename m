Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258Ab0AKLvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0AKLvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784Ab0AKLvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:51:16 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:39345 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab0AKLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:51:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mvjfrGF7VuAA0hxJYT2jLte5YkrFTpjNwDrBfD8bDeOyp6xuAaK57NXH8d71995gbF
         TU0veUihNg5Qo8sdI80YxqaCgkKJc7nXN2YxplcOdIe4PdMql1lx1Y8WzfmF2ycyPhM5
         pn+IpBYlXvLK5QnYJnesxwf7qM2L/zJENU8Fs=
MIME-Version: 1.0
In-Reply-To: <20100111105937.27d2a830@lxorguk.ukuu.org.uk>
References: <a57051ba1001110229q2ca28ffbqea37d07735debb52@mail.gmail.com>
	 <20100111105937.27d2a830@lxorguk.ukuu.org.uk>
Date: Mon, 11 Jan 2010 12:51:14 +0100
X-Google-Sender-Auth: aaff65c705bec5af
Message-ID: <a57051ba1001110351sd288fk518d6dd9a58c8724@mail.gmail.com>
Subject: Re: Monitoring file descriptors without switching context
From: Erik Rigtorp <erik@rigtorp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 11:59, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> What I really need is some way to have the hardware block and monitor
>> IO for me. Would it be feasible to implement a special low latency
>> poll() syscall that uses MONITOR/MWAIT instructions to monitor file
>> descriptors?
>
> The futex locks are probably the lowest level interface you've got for
> interlocking between tasks and are very fast. You can also pin tasks to
> groups of cpus so you can create an I/O only core for example.
>

For core to core signaling the fastest way is to use a memory polling
loop. Cache control instructions allows me to make sure I use L3 for
intra-cpu communication. The problem is that I also need to monitor
file descriptors and if I can make them fast enough that would be
preferable because I'm also signaled when they close.

Erik
