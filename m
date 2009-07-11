Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZGKOdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZGKOdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZGKOd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:33:26 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42082 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZGKOdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=rWXIHlnJMajv3Mx7hv7081DIjV6kyXDIW+9B5c6slRp2WhnbQnD/fp2itWeAJ1ATd2
         aJlKYOwHx2CArwoy+QeqXxC0tSsblUexTWJSp2ekdFH62d+skydOkpNd3DOtMwSvYPqw
         w7v8o5xX8llyCvIJX7jRWd7ZIBSYpt+B2yDzU=
Message-ID: <4A58A2A9.7020707@gmail.com>
Date: Sat, 11 Jul 2009 16:33:13 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       cpufreq@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.31-rc2+: Interrupts enabled after cpufreq_suspend
References: <4A561074.5080407@gmail.com> <20090710192511.GB6240@redhat.com> <20090710201308.GA11075@redhat.com>
In-Reply-To: <20090710201308.GA11075@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Jul 10, 2009 at 03:25:11PM -0400, Dave Jones wrote:
> 
>  >     [PATCH] Add suspend method to cpufreq core
>  >     
>  >     In order to properly fix some issues with cpufreq vs. sleep on
>  >     PowerBooks, I had to add a suspend callback to the pmac_cpufreq driver.
>  >     I must force a switch to full speed before sleep and I switch back to
>  >     previous speed on resume.
>  > 
>  > 
>  > Ben, is there something better we can do here ?
>  > 
>  > I really don't want to add an #ifdef __powerpc__ to core code if we can help it.
>  > I'd rather we didn't call into driver guts at all from the suspend path.
> 
> Marcin,
>  Unless we get a better solution proposed, try running with this, which just
> skips doing all that code entirely.

Now it produces only:
powernow-k8: error - out of sync, fix 0x2 0xc, vid 0x12 0x6
(arch/x86/kernel/cpu/cpufreq/powernow-k8.c: powernowk8_target)
but works fine.

If it's nothing to worry about, you can add:
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>

Thanks,
Marcin
