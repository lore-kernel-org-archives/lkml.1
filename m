Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXCZTap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXCZTap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXCZTap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:30:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:21317 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbXCZTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=or5q+OpPrrsAojZeF0N6x6DAIeXLpllSvirq3agN2j8dsrR8dfBSuXDzsRYbz8S9QI0mzA9EmVdsRA46zsLM2EEK3dn87kPjm9JDc5Vmc41THA3IHHOnYuVkgs7VyFlBEmi+MnC0Ro2c9hlFhBfcYfqifOj3fPrJ1QNvr9sY2WQ=
Message-ID: <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com>
Date: Mon, 26 Mar 2007 15:30:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: Fix sudden warps in mousedev
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070326121718.3940a579.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070324001610.724a820a.zaitcev@redhat.com>
	 <200703250134.03416.dtor@insightbb.com>
	 <20070325111930.f6428509.zaitcev@redhat.com>
	 <200703252319.39676.dtor@insightbb.com>
	 <20070326121718.3940a579.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Sun, 25 Mar 2007 23:19:38 -0400, Dmitry Torokhov <dtor@insightbb.com> wrote:
>
> > I tried to reproduce warping on console but could not for some reason. Could you
> > please try the patch below and tell me if it fixes the problem for you?
>
> > +++ work/drivers/input/mousedev.c
> > @@ -124,32 +124,33 @@ static void mousedev_touchpad_event(stru
> > -                             if (mousedev->pkt_count >= 2) {
> > +                     if (mousedev->touch && mousedev->pkt_count >= 2) {
>
> This works, thanks a lot.
>

Great! Then I'll queue it for 2.6.22.

> The double-indented switch() is annoying, but since the whole driver
> is written to the same style, I can live with it, for the uniformity
> purposes :-)
>

Yes, the whole input is like this so I keep it consistent.

Regarding the synaptics driver and scroll problem. Yesterday I
scrolled twice through entire Remarque's "Spark of Life" off lib.ru
(once with 0.14.2 and once with latest git pull) and did not see any
scrollbar getting "stuck". Could it be newer xorg problem instead of
individual driver problem? I am using whatever xorg was installed in
FC3 which is somewhat dated... Also, could it be that the scroll issue
happens only in a certain application?

-- 
Dmitry
