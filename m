Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbXEYIa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbXEYIa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXEYIaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:30:22 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:54938 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbXEYIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KNZzSJZrLk/oLiJt5YK7K22jJZoiQSxdOcwI7Np/0EYEivr7nAlS7/+Y0XADb+cqkgshZPI21tGBTJ52p3KkQt07h0gp7qeX8AnC8vYTVfs3tI7FpRdTX6LW0ACvwfPke+Qh7dhhR60rRwqAwRUbJ1Pjy8pT2VHthGCGWp8TEME=
Message-ID: <4af2d03a0705250130w72376b69p50c98eef405901af@mail.gmail.com>
Date: Fri, 25 May 2007 10:30:20 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com
In-Reply-To: <46569CD8.1000602@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2172422218943432279@wsc.cz>
	 <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com>
	 <4af2d03a0705241607r3c9807c6h3841e87ea4736bd3@mail.gmail.com>
	 <46569CD8.1000602@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Jiri Slaby wrote:
> > On 5/24/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> >> On 5/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > [...]
> >> > +static int stk1125_camera_asleep(struct stk11xx *dev)
> >> > +{
> >> > +     int value;
> >> > +
> >> > +     stk11xx_read_registry(dev, 0x0104, &value);
> >> > +     stk11xx_read_registry(dev, 0x0105, &value);
> >> > +     stk11xx_read_registry(dev, 0x0106, &value);
> >> > +
> >>
> >> why do you read these values (this is also something in the ongoing
> >> code I see, the read value just gets overwritten all the time)?
> >
> > Well, as I tested, reads are neccesary, otherwise it doesn't work. And
> > when they are needed, you need to read the value to some place in
> > memory -- the &value.
>
> Perhaps a few comments are warranted here and there about why some of
> those less obvious things are done.
>
> Or do it as more or less self-documenting code like
>
> static inline void
> stk11xx_unjam_registry(struct stk11xx *dev, u16 index)
> {
>         int dummy;
>
>         stk11xx_read_registry(dev, index, &dummy);
> }

yeah, seems reasonable to me.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
