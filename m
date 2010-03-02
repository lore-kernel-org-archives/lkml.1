Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0CBSDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:03:17 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54141 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0CBSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:03:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PikB08QZLLgwvfJ7N6WeHH4EnVTlyLXW1Cz79+0ZTm+smjH6mDeiNJjhnHIJ44A1FZ
         Xff4lXJUazXlceMG/DbJtwhKa8kkXofnsYAihTauWeqTvnd1oCbDSWZdHerXnSy/3qNb
         +Z6WjVdBFSPcWAf2lPl8MG8kGvMXEyhA5Q5qw=
MIME-Version: 1.0
In-Reply-To: <817ecb6f1003020951v2926c819q7bd322c40a74b4bd@mail.gmail.com>
References: <1267547013.4b8d3b8596461@imp.free.fr>
	 <817ecb6f1003020951v2926c819q7bd322c40a74b4bd@mail.gmail.com>
Date: Tue, 2 Mar 2010 13:03:14 -0500
Message-ID: <817ecb6f1003021003s4000fa4j1b357de0833db9ed@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: castet.matthieu@free.fr
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 12:51 PM, Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
>>> At this point I need some help and guidance on how to track down what
>>> exactly happens there, as I am not very familiar with what goes into
>>> .data and why are we trying to execute it.
>> Can't you add debug printk in the fault handler before any exception processing
>>
>> Something like that.
>
> That does not really give any additional information. The message does
> not show up in the output and the stack trace says that we are somehow
> ended up in doublefault_fn.

Forgot to add one more thing: it looks like fault on instruction
prefetch is already taken care of in fault handlers and should
generate an appropriate message. The way I interpret the fact that
doublefault_fn is the one that prints out a message, is that main
fault handler is somehow dependent on .data being executable.... (but
this is pure speculation on my part at this point)...
