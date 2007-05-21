Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbXEUAsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbXEUAsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 20:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXEUAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 20:47:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:52375 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXEUAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 20:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p0Coc1DT/SDe+4HSj+4T8Z9+i+7592a8msCMYAyodNcryyELELFgO1h+ZX0dV5gjio6MAsZ+MOWqdlyAAA6mTQznk40zVX6xWAv6IdzqpRn0dIMsXSefzPClyK8rvKvFZp0m6EBRlWJ8/hpQYEWS9QemABaUcbK7jyLbhx5DKls=
Message-ID: <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
Date: Sun, 20 May 2007 20:47:56 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jon Smirl" <jonsmirl@gmail.net>, "Jesse Barnes" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705201610.32170.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <pan.2007.05.20.17.41.22@gmail.com>
	 <200705201610.32170.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> With the interfaces implemented here, a userspace application can create a
> multiseat environment either with a single graphics card with multiple
> outputs or multiple cards.  It could do this by creating several frame
> buffer objects and associating them with whatever CRTCs were available,
> and managing input via existing APIs.  I don't know of anyone that's done
> this yet though...

This design still requires a global server app since the heads share a
single device.
I am always concerned that the root priv code in the X server is a
potential security hole. I would like to move away from a model where
there is a global controlling app. I don't think we need a global
controlling app at all.

By making one device per head it becomes possible to assign ownership
of the device to the specific user and let them do whatever they want
to it. It's then up to the device driver to sort everything out. fbdev
has already been designed with this in mind and I believe the Matrox
driver implements it. This model easily expands from one to N heads.

Merged-fb modes are handled by including them in the allowable modes
list on both heads. If you own both heads you can set a merged-fb mode
and the other device will just return EBUSY.

How are you reconciling the introduction of a new mode setting API
with the 90 existing fbdev drivers? We clearly don't want two
competing APIs in the kernel. What's the plan for converting all of
the existing drivers?

-- 
Jon Smirl
jonsmirl@gmail.com
