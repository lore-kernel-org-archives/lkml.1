Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZIOXHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZIOXHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZIOXHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:07:04 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:42624 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZIOXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xD7MHSAkdS1wIPZozo4aSQ3EwiwXA2PYR+brX7LxQSEbopAR5FsoK2i2mwwCufuEU+
         dzhnL+ncplIrwJ4n4S+ZiuQAejuHYj2TlQvUbpNz3Mlx+iJ6clksXnc6WQSpAgRtg53T
         JY5s+pRAPDk5PRFvWsSwEJfNb9iCKY9kJCxtk=
MIME-Version: 1.0
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7B5548192@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
	 <20090904023216.32667.55942.stgit@dwillia2-linux.ch.intel.com>
	 <129600E5E5FB004392DDC3FB599660D7B5548192@irsmsx504.ger.corp.intel.com>
Date: Tue, 15 Sep 2009 16:07:05 -0700
X-Google-Sender-Auth: d72a5f8a88bf1d1e
Message-ID: <e9c3a7c20909151607h5171784ence5e6722adab4ad7@mail.gmail.com>
Subject: Re: [PATCH 21/29] ioat2,3: dynamically resize descriptor ring
From: Dan Williams <dan.j.williams@intel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 8:00 AM, Sosnowski, Maciej
<maciej.sosnowski@intel.com> wrote:
> Making the max_alloc_order a module parameter gives impression
> that it can be modified by an user, including making it larger than default.
> The default is however its maximum value, which may be confusing.
> Why not to use parameter only as the upper limit?

It is the upper limit.

The user can limit the upper size of the descriptor ring by setting
this to a value less than 16.  By default it is the maximum ring size
that the driver/hardware* supports.  Specifying values greater than 16
are not supported by the so we need enforce a ceiling at 16.

--
Dan

* We could support ring sizes larger than 1 << 16 but we would need to
extra logic to ensure that the pending count never exceeded 1 << 16.
Simpler I think to just limit the maximum ring size.
