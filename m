Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZL2SMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZL2SMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZL2SMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:12:47 -0500
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:50955
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZL2SMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:12:46 -0500
Message-ID: <4B3A4698.4080705@wilsonet.com>
Date: Tue, 29 Dec 2009 13:12:40 -0500
From: Jarod Wilson <jarod@wilsonet.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Jarod Wilson <jarod@redhat.com>,
       linux-input@vger.kernel.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR
 devices
References: <20091228051155.GA14301@redhat.com> <20091229164856.GA29476@bicker>
In-Reply-To: <20091229164856.GA29476@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 12:01 PM, Dan Carpenter wrote:
>
> I ran smatch (http://repo.or.cz/w/smatch.git) on it and there are
> some bugs worth fixing.
>
> drivers/input/misc/imon.c +331 free_imon_context(7) error: dereferencing freed memory 'context'
> Move the debug line earlier.
>
> drivers/input/misc/imon.c +1812 imon_probe(216) error: dereferencing undefined:  'context->idev'
> drivers/input/misc/imon.c +1876 imon_probe(280) error: dereferencing undefined:  'context->touch'
> The allocation func can return NULL.  They probably won't fail in real
> life, but it will slightly annoy every person checking running smatch
> over the entire kernel (me).
>
> drivers/input/misc/imon.c +1979 imon_probe(383) error: double unlock 'mutex:&context->lock'
> drivers/input/misc/imon.c +1983 imon_probe(387) error: double unlock 'mutex:&context->lock'
> It sometimes unlocks both before and after the goto.

Yeah, I think I've actually already fixed every one of these problems in 
the past 24 hours (a few just a few minutes ago), stay tuned for a 
repost, hopefully later today. :)

Thanks much,

-- 
Jarod Wilson
jarod@wilsonet.com
