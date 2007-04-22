Return-Path: <linux-kernel-owner+w=401wt.eu-S1030810AbXDVM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810AbXDVM5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030837AbXDVM5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:57:46 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:20085 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030810AbXDVM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YozjeU2F8/mMekYaqsiNZeNgYycwybtYy24QcniRH1ti7igkTm3Vj0Zj3Q0M2n6zCarCJc6S40FV9DDANmoCGivPW/S+95Pcryh9paZYZ3g7e3Na0RLb9G18HXvY6YCIBDLaj8B/y9qs7hsNp/4YwPHlGBIwTTRuLMgRz4ugj2E=
Message-ID: <4af2d03a0704220557u5d6368a2t13878b73bf9dbe64@mail.gmail.com>
Date: Sun, 22 Apr 2007 14:57:44 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Cc: "johann deneux" <johann.deneux@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <d120d5000704190902o60aa4b19y77728585e22b2e84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com>
	 <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
	 <200704190058.11625.dtor@insightbb.com> <46278CDD.2000007@gmail.com>
	 <d120d5000704190902o60aa4b19y77728585e22b2e84@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On 4/19/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > Dmitry Torokhov napsal(a):
> > > If we are interested in using FF API we need to come up with a way
> > > to express this effect without exposing implementation details of
> > > one particular device.
> >
> > Still, torques are better named raw/motor values, which goes to the device
> > and I'm sceptic about inventing something class-better than this.
> >
>
> Well, I guess we need to make a decision whether moving this kind of
> devices into a force feedback layer is possible or whether every
> device needs to have an application specifically tailored to that
> particular device.
>
> If we say that it is feasible to plug a device into FF layer then we
> must not expose hardware implementation details. That means that
> device-sepcific translation between 3d vector of forces into motor
> torques must be done by the driver itself.

Hmm, it's 3d at minimum (the glove has 14 torque points, phantom up to
6), I think we won't be able to make the transition in independent way
due to unspecified meaning of the torques.

> For devices that require tailored application (for example that glove
> - I am not sure how a generic application could control it) old
> phantom way of controlling via ioctl will suffice. The device may
> still use input layer to report back coordinates.

Ok, nobody seems to have an idea, I'm going to avoid FF layer in the
code and hope this is the final change ;).

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
