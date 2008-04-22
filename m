Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYDVSK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYDVSK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYDVSKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:10:48 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:23734 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYDVSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=clDm6vT+kmKINl2+MJAlcKCR1wRglZ9Ji/BQx4nGkLzOZQ2vdVvmSBJZzZrKBn2TpQ4GUQwJrTESOsADZBRFvmBMga3+np+S78/UhIwsHN481eZTSqr7FhMbjsqT7yWSGZpDmemVtMKDQIfuOt2c7Btza9mdchn50HcS0DGZaYU=
Message-ID: <e9c3a7c20804221110y1968dfb3q27b86c9a7480ad1@mail.gmail.com>
Date: Tue, 22 Apr 2008 11:10:41 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [dm-devel] Re: [RFC][PATCH 0/10] I/O context inheritance
Cc: "Hirokazu Takahashi" <taka@valinux.co.jp>, linux-kernel@vger.kernel.org,
       agk@sourceware.org
In-Reply-To: <20080422145418.GL12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080422.224935.00673711.taka@valinux.co.jp>
	 <20080422.230318.112756414.taka@valinux.co.jp>
	 <20080422145418.GL12774@kernel.dk>
X-Google-Sender-Auth: a69a274854575302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 7:54 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Apr 22 2008, Hirokazu Takahashi wrote:
>  > Hi,
>  >
>  > Sorry, these patches are for linux-2.6.25.
>  >
>  > > This series of patches make the block I/O layer and the I/O schedulers
>  > > be able to determine the right io_context of every I/O.
>  > >
>  > > The current implementation of the block I/O layer and the I/O schedulers
>  > > assume that the current process is the one which issued the given I/O,
>  > > then use the io_context of this process to control the I/O.
>  > > But this assumption isn't quite right because several kernel threads
>  > > will handle I/O requests on behalf of the processes which originated them.
>  > > This often happens when you want to use device mapper modules.
>  > >
>  > > The patches make every bio has a pointer to an io_context, which will
>  > > be set when it is allocated or cloned. So it makes it possible to find
>  > > the right io_context from any bio at any place.
>  > >
>  > > I'm waiting for your comments.
>
>  Can you give a brief summary of what you need this stuff for?
>

I am not sure if this the intended application, but I have been
looking at supporting ionice over software-raid and this series seems
like a necessary first step.

--
Dan
