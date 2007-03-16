Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXCPOaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXCPOaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965170AbXCPOaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:30:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:43379 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865AbXCPOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jy3AjhEGPRw1hZ3zAzNvmjQekbw6U69PISwY/sEeGA2Ez2D5xMv4zSkkWGsUA03n3PrIqWCg40zusF3GVSuKZzAkue/DTQYZw+nFkuib8c6hUyudedPDLZB3SnDKivUAkMkhwn2Ot3TAUZq76AYV2vITyt04/M0tsTCK4e7bhco=
Message-ID: <84144f020703160730y7cd692efx264635fe4683398b@mail.gmail.com>
Date: Fri, 16 Mar 2007 16:30:04 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/5] revoke: core code
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20070316145855.5604d7d8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	 <20070315173438.efadd514.akpm@linux-foundation.org>
	 <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
	 <20070316032624.c6db84fc.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
	 <20070316042600.3e1bd424.akpm@linux-foundation.org>
	 <20070316145855.5604d7d8@lxorguk.ukuu.org.uk>
X-Google-Sender-Auth: 9061f59ad0f2201f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > I'm not sure that running do_fsync() will guarantee that all sys_write()
> > callers will have finished their syscall.  Probably they will have, in
> > practice.  But there is logic in the sync paths to deliberately bale out
> > if we're competing with ongoing dirtyings, to avoid livelocking.
>
> For device files you really need to call into the device driver for this
> (->flush etc).

Sure but the do_fsync() bits are part of generic_file_revoke() which
is not meant for device files at all.
