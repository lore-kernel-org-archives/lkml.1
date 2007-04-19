Return-Path: <linux-kernel-owner+w=401wt.eu-S1766826AbXDSQCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766826AbXDSQCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766828AbXDSQCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:02:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:22934 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766826AbXDSQCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r8E5hsP3gHylQryVLjULpgEEt342wEMQpRRz+bLQNZsZST8MrO2PHtCT2D035WxUJiKWLP4xvdHv0SVD/troAyUriLRo+q61MKHgzPdWTY1rESRprMSZWf24BZCAT7ceSc++Jmw+riRiQRrXvZUAKEixPJlcz3GtiVMdbhxJ8dg=
Message-ID: <d120d5000704190902o60aa4b19y77728585e22b2e84@mail.gmail.com>
Date: Thu, 19 Apr 2007 12:02:21 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Cc: "johann deneux" <johann.deneux@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <46278CDD.2000007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com>
	 <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
	 <200704190058.11625.dtor@insightbb.com> <46278CDD.2000007@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dmitry Torokhov napsal(a):
> > I have been thinking about this and I don't think that exporting motor
> > data is a good idea, at least not in case of Phantom driver. The fact
> > that there are 3 motors is a hardware implementation detail and it
> > is not interesting for general application.
>
> Ok, so what about torques (despite it's still something like FF_RAW or motor
> descriptor)? It seems not to be so bad called effect name -- not only
> phantom uses torques on motors as an unit of force, for example I get this
> by quick googling:
> http://www.caip.rutgers.edu/~bouzit/lrp/glove.html
> They use there some motors with 14 torque values too, so the phantom isn't
> the only device which uses this approach.
>
> > My understanding that the end result of controlling these 3 motors
>
> Actually there is also a version with 6 motors :).
>
> > is a force vector (I don't know if there is such english term, this
> > is a literal translation from russian) applied to user's hand.
>
> Better say torques vector. You must compute a torque for each place from the
> 3d (or bigger) vector of forces in different way for each device that exists
> -- this means forces are not independent unit, torques are in the meaning of
> layer which doesn't care about what is connected above and below it.
>
> > If we are interested in using FF API we need to come up with a way
> > to express this effect without exposing implementation details of
> > one particular device.
>
> Still, torques are better named raw/motor values, which goes to the device
> and I'm sceptic about inventing something class-better than this.
>

Well, I guess we need to make a decision whether moving this kind of
devices into a force feedback layer is possible or whether every
device needs to have an application specifically tailored to that
particular device.

If we say that it is feasible to plug a device into FF layer then we
must not expose hardware implementation details. That means that
device-sepcific translation between 3d vector of forces into motor
torques must be done by the driver itself.

For devices that require tailored application (for example that glove
- I am not sure how a generic application could control it) old
phantom way of controlling via ioctl will suffice. The device may
still use input layer to report back coordinates.

-- 
Dmitry
