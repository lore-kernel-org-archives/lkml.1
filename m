Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbXLDQsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbXLDQsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbXLDQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:47:58 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:7199 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbXLDQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KYEAW1N4DLjdiSJLPXgGkVPj6w5C0kcnZxJIajLt4w44a+NhOq83+e2IxtbwodROw1y5Nfh+Oe0nDkfLOODZ44dIqiPTmWKXyzHgUKzQn3J9McsrMapE4tsXunzi6wBTwNLuepG/2XIud500BcDV3e1EHvfSuv6HRehXAI237cU=
Message-ID: <8bd0f97a0712040847m73bb479dx814d83985e5223d5@mail.gmail.com>
Date: Tue, 4 Dec 2007 11:47:56 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alessandro Zummo" <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 1/7] Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
Cc: rtc-linux@googlegroups.com, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <20071204174146.19bedb54@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
	 <1195812512-25979-2-git-send-email-bryan.wu@analog.com>
	 <20071204172634.50492e1e@i1501.lan.towertech.it>
	 <8bd0f97a0712040829i116496deu384453c6eccfa252@mail.gmail.com>
	 <20071204174146.19bedb54@i1501.lan.towertech.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 11:41 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> On Tue, 4 Dec 2007 11:29:11 -0500 "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > On Dec 4, 2007 11:26 AM, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > > Bryan Wu <bryan.wu@analog.com> wrote:
> > >
> > >  Hi, I fannly got some time to review the patches. Seems ok, the
> > >  only question is...
> > >
> > > > static int bfin_irq_set_freq(struct device *dev, int freq)
> > > >  {
> > > > -     struct bfin_rtc *rtc = dev_get_drvdata(dev);
> > > >       stampit();
> > > > -     rtc->rtc_dev->irq_freq = freq;
> > > > -     return 0;
> > > > +     return -ENOTTY;
> > > >  }
> > >
> > >  .. why ENOTTY here?
> >
> > that's what the documentation says to do as does every other rtc driver ?
>
>  it should be EINVAL. at least it is wat rtc-cmos does when the value
>  is invalid.

the return of ENOTTY is to say "changing of freq isnt supported", not
that the value is invalid.  but i can get the same behavior by
deleting the function as the rtc-dev layer will take care of returning
ENOTTY.

so the behavior is for the RTC_IRQP_SET ioctl:
 - return ENOTTY if you cannot change freq
   - the rtc-dev layer will do this for you if you do not set irq_set_freq
 - return EINVAL if the requested freq is not within the capabilities
of the hardware

sound about right ?
-mike
