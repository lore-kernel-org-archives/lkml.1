Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYGQTHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYGQTHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYGQTHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:07:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:50127 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbYGQTHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=LLbTue5n6xZ9fm1v/DaZBh8H5Oq9+oDF5Mcl1lr92oUo450D7JWvvdwcFKAOIFq6l2
         rHZo+0VIwyLOLtIYVW3jnAzt9fPJqd+qTjBmqeUobdJNBth2TvOJ0y44W9jBp4hTp2FM
         /lVfZm74s3ueowE/gLgDirESLlpEHxsKNGcyM=
Message-ID: <487F986A.3070504@tuffmail.co.uk>
Date: Thu, 17 Jul 2008 20:07:22 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net> <487F7724.5080905@tuffmail.co.uk> <20080717185032.GD18457@khazad-dum.debian.net>
In-Reply-To: <20080717185032.GD18457@khazad-dum.debian.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 17 Jul 2008, Alan Jenkins wrote:
>   
>> Actually Alexey has another patch in bugzilla (#10919) which resolves
>> this issue in a better way.  It avoids polling altogether, which is good
>> because it means you get events immediately.  My laptop has backlight
>> adjustment hotkeys with hardware autorepeat, so it looks really jerky
>> with polling.
>>     
>
> We need to get ALL pending events from the EC, whether in polling mode or in
> interrupt mode 

> (and we must make sure that we ARE going to queue any new
> interrupt before we stop checking for an empty pending event queue,
> otherwise there is a small window where a new event might get queued, and we
> are still masking the GPE and don't notice it).  As long as the fix does
> that, it is all I care :-)
>   
OK, I forgot about that. I need to do some reading on kernel
programming, workqueues in particular, and redo my patch again. Sorry,
Alexey! AFAICS there's still this (very) small window where events could
be dropped.

Alan
