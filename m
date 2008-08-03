Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYHCK1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYHCK1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 06:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYHCK1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 06:27:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:33470 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHCK1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 06:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=IeGKAP1CLzFSSQQl2WAnesB/2594emu6NRDSlLvM7owKtsJ4RVF2qvhD+LBLdEHI3R
         B3VBWNUTLJL3Vriby0qBaF+eokQSSzaQ9D1mfiQ1SXPc5RClmLJEE8MTnbIVe4GMnSp+
         4lUgACCHe5efVtvO+7Ahw1v5FmS9/xbtiwuXU=
Date: Sun, 3 Aug 2008 15:56:51 +0530
From: Rabin Vincent <rabin@rab.in>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge.A.S@tochka.ru, mxhaard@users.sourceforge.net, moinejf@free.fr,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: Re: gspca_zc3xx oops - 2.6.27-rc1
Message-ID: <20080803102651.GB4178@debian>
References: <82e4877d0808020922x64177318j6f8fe15955704521@mail.gmail.com> <20080803073705.GA2754@debian> <82e4877d0808030052g4c345811u642667b2a8d87a1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0808030052g4c345811u642667b2a8d87a1d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 03:52:24AM -0400, Parag Warudkar wrote:
> On Sun, Aug 3, 2008 at 3:37 AM, Rabin Vincent <rabin@rab.in> wrote:
[..]
> > Now sd->gamma shouldn't be zero because in sd_ctrls, the minimum value for it
> > is set to 1.  This range should be checked by vidioc_s_ctrl in gspca.c, and we
> > have this there:
> >
> >               if (ctrl->value < ctrls->qctrl.minimum
> >                   && ctrl->value > ctrls->qctrl.maximum)
> >                        return -ERANGE;
> >
> 
> Sounds more appropriate but I am not sure how vidioc_s_ctrl leads to
> the call trace in the OOPS - at least it doesn't show up there.

The call trace is for the ioctl which starts the capturing.  However,
the gamma value is not set when starting the capturing, but would have
been set earlier using a separate ioctl -- that one would have gone
through vidioc_s_ctrl.

Rabin
