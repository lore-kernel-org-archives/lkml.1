Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXJ0SKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXJ0SKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXJ0SKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:10:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:11153 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXJ0SKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EkFUnR0GV7qtAq9VM2LgHPeUepYr2L/DLWFox410TJe3P56D4yTFc3Mbr1hq0q9tKpwqulCUojf+fQ7YrSSWjThGD9vWmPdMVQxVf3x6kSAJ1TwUyRqGYiWjnGv8MQiX4g79d5RfsP67OYWn/dxJZR1fxw6El7blq5eTV3Zlnrc=
Message-ID: <e9c3a7c20710271110s4c8c2654qc11ecf2054eb0492@mail.gmail.com>
Date: Sat, 27 Oct 2007 11:10:29 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20071027155807.73976b0a@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	 <e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
	 <20071024201616.02f87b20@siona> <20071025113240.466b69ba@siona>
	 <e9c3a7c20710261002m1c5063bdqa040834c30d9ca8a@mail.gmail.com>
	 <20071027155807.73976b0a@siona>
X-Google-Sender-Auth: 62b0aec256084f0c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
>
> Yeah, it's a pretty serious bug if the DMA engine flags an error. But
> wouldn't it be better to BUG() in the context of the caller? That way,
> you won't necessarily bring down the whole system.
>

I see your point...  We could track the caller's task_struct in
dma_async_tx_descriptor, and deliver a SIGBUS in the case of an error.
 It limits the client's recovery options, but at least the damaged is
localized to the correct process.  I need to go read up on what this
would imply for kernel threads like raid5d...
