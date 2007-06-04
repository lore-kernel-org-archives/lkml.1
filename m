Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXFDQWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXFDQWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXFDQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:22:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:32266 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXFDQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IFO1Sdy4WE8IpgcVxgmKKRJV7FmBHHzEbn7Hc8KEJZikGsZqZtf3mgnAkaXrZBjEMaWXPpR5BIOoyz30F7nh6L3XXCY0BlPbuH9TGDIRU+X2AKIA8ItiKIaxOds3M96uvEVlE4htyImZCvdApqHq2P/i/5xPTPFCdNpREWdA0LU=
Message-ID: <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
Date: Mon, 4 Jun 2007 19:22:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
In-Reply-To: <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	 <20070601204141.f84ad72f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	 <20070601213117.1178e8e0.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
	 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
	 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 1f535dc7d853169b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Christoph Lameter <clameter@sgi.com> wrote:
> We are doing that right now. The problem is that people keep storing stuff
> in memory allocated with kmalloc(0).

Ok, makes sense. I guess I might as well throw my suggestion in the
mix. Lets create a new kmalloc cache for zero-length objects where
object size is zero but there are regular red-zones on both sides.
