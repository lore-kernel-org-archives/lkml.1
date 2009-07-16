Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbZGPXo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbZGPXo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933628AbZGPXo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:44:27 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:41775 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbZGPXo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IllWnhdTUO5DyaraxFyExUWM3OtPuQ8aMwNg0LYLXK7sbRZ2op5uBb6QssKnEPVQ3C
         /KJxi0UDtO31jbj9z/n800ANoDm8wb0XswdPKQ7VCRT72WdLCPwxI+N1yf5TA2MGbpxz
         dQKU/RRRV9PK2ZmZ6HWOULcWbwBp4RGODrzo8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] add "VmUsers: N" to /proc/$PID/status
Date: Fri, 17 Jul 2009 01:44:27 +0200
User-Agent: KMail/1.8.2
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200907150322.18123.vda.linux@googlemail.com> <200907162327.25700.vda.linux@googlemail.com> <63188.1247786645@turing-police.cc.vt.edu>
In-Reply-To: <63188.1247786645@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907170144.27775.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 July 2009 01:24, Valdis.Kletnieks@vt.edu wrote:
> > I, indeed, want to have just an N I can divide RSS/VSZ/etc by,
> > to get, say, top display which do not mislead user
> > into thinking that he has 3 processes with 100 megabyte RSS
> > when in reality he has 3 processes sharing a single VM
> > with 100 meg RSS.
> 
> Thinking about it a bit more - it's probably *usually* possible to sort out
> which processes are sharing because if you have 2 sets of shared memory,
> they'll *usually* have different RSS values - so the 2 processes with a
> count of 2 and an RSS of 179M are one set, and the 2 processes with a count
> of 2 and an RSS of 198M are probably another.

Hmm. We can just expose the raw value of task->mm pointer.
For all tasks which share a VM, it will have the same value.

It would be an "information leak", yes, but it isn't obvious
whether it can be exploited at all. We can also obscure it
a bit by XORing or summing it with randomly selected constant
or some such.
--
vda
