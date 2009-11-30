Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZK3LTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZK3LTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZK3LTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:19:31 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:57874 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZK3LTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:19:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n1pOadee/S1HbZMb/XMBGFW06yTohMVCFJJyoJO0uTGSPNTTuLXVWq4eX9MZLcpMqz
         gyKw2W8MZxOz9zs/5CjDQx1B3QC+/m+UXr/3XcYLj/exfmcwKFhVMpeH9XBBadYj4jBl
         4oAGYBVEX5rB2c3rD2uC874A7Q4DrektyE9gQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911281457560.24119@localhost.localdomain>
References: <20091125081235.25416.32481.sendpatchset@rxone.opensource.se>
	 <20091125081255.25416.85126.sendpatchset@rxone.opensource.se>
	 <alpine.LFD.2.00.0911281457560.24119@localhost.localdomain>
Date: Mon, 30 Nov 2009 20:19:36 +0900
Message-ID: <aec7e5c30911300319i115efdb6p215984377cb97f22@mail.gmail.com>
Subject: Re: [PATCH 02/02] clocksource: Start CMT at clocksource resume
From: Magnus Damm <magnus.damm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-sh@vger.kernel.org, johnstul@us.ibm.com, lethal@linux-sh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, Nov 28, 2009 at 11:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 25 Nov 2009, Magnus Damm wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> Add code to start the CMT timer on clocksource resume.
>>
>> This makes sure the timer is started during sysdev_resume().
>> Without this patch the clocksource may be read as suspended,
>> this after sysdev resume but before platform device resume.
>
> Hmm, don't you have the same situation on suspend ?
>
> platform device suspend stops the clock, but the generic code expects
> it to be running until sysdev shutdown.

You are correct, the same situation exists on suspend.

> Another thing is that you now run both, the sysdev and the platform
> resume. Is that by design or accident ?

By incorrect design. =)

To fix this properly I was thinking of adding a clocksource suspend()
callback and ditch the platform ops all together. If you don't mind
then I'll post a patch for that tomorrow!

Thank you!

/ magnus
