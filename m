Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbXGFGf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbXGFGf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbXGFGfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:35:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:22518 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbXGFGfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kzi+I2+HNyzVTU/vFv/H7MbzH1doNZVVFq6wOMrq/bh40DCShlBYDHEm4tP6mrlXy0aog0NYkPMoJ5hQI2GpvylTkyiaQ/GH8IVe26UIWE7mJhHR7KOPqPE0OAt/jVmhCfB5xxiuBiBlxOywBZw4Rz18x/UbWWhXZTmXr15E4Gc=
Message-ID: <9a8748490707052335i4077fec6ofe8b37e2a86e3c8e@mail.gmail.com>
Date: Fri, 6 Jul 2007 08:35:46 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Kaleem Khan" <linuxuser8@gmail.com>
Subject: Re: kill -9?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7dce480a0707052321nacc0f10x2e20171760b97705@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7dce480a0707052321nacc0f10x2e20171760b97705@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/07, Kaleem Khan <linuxuser8@gmail.com> wrote:
> Hello Kernel experts,
>
> I'd like to know whether there's a way to take some action (say
> calling a routine) in
> response to 'kill -9' before the process is terminated. I tend to
> think it's against 'kill -9'
> UNIX/Linux philosophy but still I'd like to confirm.
>
You can't catch/block SIGKILL (9), but you can catch SIGTERM (15 -
what kill sends by default).

A well behaved app should catch SIGTERM and do proper cleanup before
shutdown so that when a user does  kill <pid_of_app>  it shuts down
cleanly.  kill -9 <pid_of_app> shouldn't normally be needed - it is
for emergency termination of the app, which is why you can't catch it.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
