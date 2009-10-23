Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbZJWJeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbZJWJeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZJWJeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:34:11 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:53287 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZJWJeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PbDorzE6OVj4Pno+anEivLO3H1kkJ/clpRdsucnAQOL1K3mazW5EYu1hHD+qIGlbyg
         //n9JiOWdtsQKCvtLgIZRNSJKMaPLmIP63ErUX+/unl0Qx/PCZx0llGOGFNELzqk4pFp
         5yX+kk8rytSOlJmqnrF1F1r9lT4mlOmcQqYeE=
MIME-Version: 1.0
In-Reply-To: <4AE165A1.5080204@ladisch.de>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
	 <5048.1256224623@turing-police.cc.vt.edu>
	 <f22d86810910221046l366d3017r8b8823e4750ffea2@mail.gmail.com>
	 <4AE165A1.5080204@ladisch.de>
Date: Fri, 23 Oct 2009 02:34:15 -0700
Message-ID: <f22d86810910230234qed58b28g920a98bb3720b146@mail.gmail.com>
Subject: Re: Can current macro be accessed from interrupt context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no fixed association between your tasks and the CPUs they are
> running on.  It is possible for two of your threads to be executed on
> the same CPU (one after the other), or for one thread to migrate between
> CPUs.

Yes, you are right. I had not thought about thread migration etc and was
painting a rather simple picture of things.

>
> The task that was interrupted is probably some entirely different task
> (the X server, the shell, your mail reader, some kernel thread, or
> any of the other tasks running on your system).
>
> It is possible for your interrupt handler to be called for some device
> request that belongs to one of your tasks that is currently running on
> another CPU, so you won't be able to manage that data without locking.
>

Yes, this is pretty much points towards using per-cpu data.
Seems like my thought experiment will lead to an early demise.

Thanks for the explanation.


-Leo.
