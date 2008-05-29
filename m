Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYE2V5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYE2V5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYE2V5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:57:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:47733 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYE2V5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a+LhjFcBRPnjV7G/2nny9gex2HCJEu8xoV1OaJDGRAnI2Ew+JEK/74MWPVWA5fPfjF3nmWuX3eje5HOIwX3NTKdkhz40Bpj1Y8m2bLlVLPsCADMikh1JqsxZX+h/+u/53kMzPJO1xbQbF9ba6/xnqbGVnv/gQ1FzG9+Epq3Su2M=
Message-ID: <86802c440805291457r71340133pc413b7f1e78e5df3@mail.gmail.com>
Date: Thu, 29 May 2008 14:57:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the kernel.
Cc: matthew@wil.cx, arjan@linux.intel.com, greg@kroah.com,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080529.143157.02330907.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483F1232.4010003@linux.intel.com>
	 <20080529204736.GZ22636@parisc-linux.org>
	 <86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
	 <20080529.143157.02330907.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 2:31 PM, David Miller <davem@davemloft.net> wrote:
> From: "Yinghai Lu" <yhlu.kernel@gmail.com>
> Date: Thu, 29 May 2008 13:55:16 -0700
>
>> driver should check fw version...
>
> This alone is not a reason to rip the firmware out into a seperate
> tree.  And I am absolutely not convinced that the cases where this
> matters all universally even use firmware versions.
>
> I've installed the wrong ipw2200 on several occaisions.
>
> Furthermore, it's about distributing what works with what it's meant
> to work with.  With this seperate scheme, I can still link in the
> wrong firmware file (the driver doesn't check the firmware version
> until it executes) and the driver won't work.  So this moves the
> validation to run time, which users typically don't appreciate.

I agree. I hate to have two klibc (one for 32 bit, and one for 64bit)
to for initramfs to load FW for qlogic...

dwmw2 's new patches to put all fw in /firmware, and built them into
kernel could avoid that...

and could make the build process to check fw version to match with
driver in different kernel version later...

YH
