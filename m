Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbYEBIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbYEBIr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYEBIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:47:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:4242 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYEBIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pelfirTOWBB4pLGSLDmd/aHPELstC+ts5bPvFVrVmfMrBk3z1x7+vdG+t7V1Mqnswv0g1AC+jqDj973twi2XlCSuowB3yrGR8pWJTeJhYn3XADIdDU4RwjG1NYvIU2rO2waXikTY8Djo/z13YuIxIhFXt8sJua1ozUwiT7vp8Eg=
Message-ID: <481AD528.1090809@gmail.com>
Date: Fri, 02 May 2008 10:47:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86_64: fix mm.txt documentation
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com> <20080502072226.GB713@elte.hu> <20080502083805.GR20451@one.firstfloor.org>
In-Reply-To: <20080502083805.GR20451@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2008 10:38 AM, Andi Kleen wrote:
>> yep, the image was in a 128 MB chunk from which 88 MB was left empty and 
>> modules started at the next 128 MB boundary. The largest image i ever 
>> had was around 44MB, so i doubt it's an issue in practice. Mind doing a 
>> patch that reinstates it, by lowering the 512 image size limit to 508 
>> MB? [4MB should be more than enough in practice]
> 
> Actually you could even limit to the exact know size of the kernel (rounded
> up to 2MB) after early boot. Then the protection would be even better and less
> aliasing to deal with for pageattr.c. Just invalidate the left over PMDs.

Doesn't cleanup_highmap() do that? ... so I guess we don't need the hole? Or do 
we when we reach the limit to not go over to modules?
