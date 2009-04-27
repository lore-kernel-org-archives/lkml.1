Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbZD0OwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbZD0OwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbZD0Os3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:48:29 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53367 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbZD0Os1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CO3LpJGBOUl70/rxqi7dTXTR8QApi9D0SkbO6o9e6W60U1AEx1tmxm3cJyYzU+2HLU
         56VODnkdEbCF/aoAou/8zy+a+QkaUL47w5h49vl6qYzQfvuVCA0K4ChgugOHpPH+yGTH
         CGsm6vLa/YLQYaX8wvykvrMzmG7W70dfCs0rY=
MIME-Version: 1.0
In-Reply-To: <407d949e0904270635p7f87e3c3jcb1db0e61d4ed11e@mail.gmail.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
	 <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
	 <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
	 <407d949e0904270635p7f87e3c3jcb1db0e61d4ed11e@mail.gmail.com>
Date: Mon, 27 Apr 2009 16:48:25 +0200
Message-ID: <40a4ed590904270748x7630ce79rd1e1c82b8fabb38e@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: Greg Stark <gsstark@mit.edu>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 3:35 PM, Greg Stark <gsstark@mit.edu> wrote:
> On Sun, Apr 26, 2009 at 8:55 PM, David Rientjes <rientjes@google.com> wrote:
>> There is work being done on a per-cgroup lowmem notifier which would allow
>> userspace to poll() on a device file and be notified of low memory
>> situations so that it can react on its own (like killing a low priority
>> task, expanding a cpuset, increasing a memcontroller limit, etc.)
>
> Surely anything that important ought to be running with overcommit
> disabled anyways.

Ok, I tried this suggestion as well. I done:

echo 2 > /proc/sys/vm/overcommit_memory

echo 0 > /proc/sys/vm/overcommit_ratio (Note: our system does not have
any swap, just 32 GB of memory).

Then I tried to run "htop" and got

bash: fork: Cannot allocate memory

I also tried it with

echo 1 > /proc/sys/vm/overcommit_ratio

Same result.

Best
Zeno
