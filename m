Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbXEDMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbXEDMwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXEDMwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:52:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:22694 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbXEDMw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=InxkuitcJCRBYy7Flz1HMeQxb1r9zo6JPoszqO/6PSBS0IoIFPoewR/XpWN8LcSBv6vsCbrjW7gOFAg5zXJVNJdi7G4EiynhRAg8ey8RcketwPz3dCfIcsMddiQ03ihmx2s9R/MzwJqHwsmBRT56lh46SDhCJB3VnOtiTanqOjc=
Message-ID: <4240b9160705040552n222126a2iadef5452c722b63@mail.gmail.com>
Date: Fri, 4 May 2007 14:52:26 +0200
From: "Jerome Glisse" <j.glisse@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Cc: "Keith Packard" <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
       "Dave Airlie" <airlied@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <463B27C4.3040304@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
	 <1178251621.27028.9.camel@neko.keithp.com>
	 <463AE9AE.7070806@tungstengraphics.com>
	 <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
	 <463B12F9.8060900@tungstengraphics.com>
	 <4240b9160705040457n46be9b62p7c760fb54898ba37@mail.gmail.com>
	 <463B27C4.3040304@tungstengraphics.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Thomas Hellström <thomas@tungstengraphics.com> wrote:
> I was actually referring to an example where two clients need to have a
> buffer mapped and access it at exactly the same time.
> If there is such a situation, we have no other choice than to drop the
> buffer locking on map. If there isn't we can at least consider other
> alternatives that resolve the deadlock issue but that also will help
> clients synchronize and keep data coherent.
>
> /Thomas

One might be a texture where a portion is updated by one thread
and another portion update by another one, i believe the application
will know better than us if such concurrent access will conflict or not.
If this both thread access different pixel it make sense to let them
work together at the same time on the texture. If they are writing
to same pixel then they will have to sync between them so they
don't do somethings stupid.

My point is that the user space will know better if sync is needed
or not and how to sync access to the same buffer. Moreover we
can still add a locking mechanism in user space (in libdrm for
instance).

There is very likely others use case for such concurrent access which
i can't think off right now.

best,
Jerome Glisse
