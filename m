Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZGOP1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZGOP1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZGOP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:27:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:65446 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZGOP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fmNvfwATWNiPpqP2nkbnqesO0paEmj+QVPM75nZPRsboswQnO3pdSeACFxKoMOoSO4
         TEFxg7oC/rYBRITh1e7Is+I0Xe1QyV/TxLYe5wm9jDFDVFKL6DKUz4sousKFoDviXmjL
         mSbxAzluntYOw1H8EN1m1z39f/+fYy4wILTMI=
Date: Wed, 15 Jul 2009 08:27:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Support for synaptic touchscreen in HTC dream
Message-ID: <20090715152702.GB21611@dtor-d630.eng.vmware.com>
References: <20090714100634.GA4054@elf.ucw.cz> <20090714175201.GB14661@dtor-d630.eng.vmware.com> <20090715134855.GB2538@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715134855.GB2538@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Jul 15, 2009 at 03:48:55PM +0200, Pavel Machek wrote:
> On Tue 2009-07-14 10:52:12, Dmitry Torokhov wrote:
> > On Tue, Jul 14, 2009 at 12:06:34PM +0200, Pavel Machek wrote:
> > > +	input_report_abs(ts->input_dev, ABS_PRESSURE, z);
> > > +	input_report_abs(ts->input_dev, ABS_TOOL_WIDTH, w);
> > > +	input_report_key(ts->input_dev, BTN_TOUCH, finger);
> > > +	finger2_pressed = finger > 1 && finger != 7;
> > > +	input_report_key(ts->input_dev, BTN_2, finger2_pressed);
> > > +	if (finger2_pressed) {
> > > +		input_report_abs(ts->input_dev, ABS_HAT0X, pos[1][0]);
> > > +		input_report_abs(ts->input_dev, ABS_HAT0Y, pos[1][1]);
> > 
> > ABS_HAT is pretty unusual for a touchscreen...
> 
> It is trying to do something useful for multitouch. People actually
> use multitouch on HTC dream. I guess I can strip it from version being
> merged...
>

What about converting it to emit ABS_MT_* events added specifically
for the multitouch protocol?

> 
> > > +	ts->input_dev->name = "synaptics-rmi-touchscreen";
> > 
> > BUS_I2C, etc.
> 
> I figured out BUS_I2C. Anything else I need to set?
> 

No, just set what you know. It is purely to help userspace identify the
device.

> 
> > > +	if (client->irq) {
> > > +		ret = request_irq(client->irq, synaptics_ts_irq_handler,
> > > +				  0, client->name, ts);
> > 
> > I think threaded IRQ will fit the bill and will take care of
> > IRQ/workqueue shutdown races. Of course you still need to use workqueue
> > if polling.
> 
> I guess we'll just strip polling version for now?
> 

Well, is it useable in polling mode? Do we forsee any devices using it
that way? If no then shure, strip it out.

-- 
Dmitry
