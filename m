Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYFQQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYFQQem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYFQQed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:34:33 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:33331 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYFQQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:34:32 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, arbrandes@gmail.com
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
References: <871w2xnehf.fsf@old-tantale.fifi.org>
	<Pine.LNX.4.64.0806171557440.10085@jikos.suse.cz>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 17 Jun 2008 09:34:21 -0700
In-Reply-To: <Pine.LNX.4.64.0806171557440.10085@jikos.suse.cz>
Message-ID: <87skvckoky.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Mon, 16 Jun 2008, Philippe Troin wrote:
> 
> > Jiri & all,
> > What's the status on this bug?
> > I used this patch for 2.6.24:
> > diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> > index 0b27da7..fc6e77e 100644
> > --- a/drivers/hid/hid-input.c
> > +++ b/drivers/hid/hid-input.c
> > @@ -802,6 +802,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
> >  		case HID_UP_LOGIVENDOR:
> >  			set_bit(EV_REP, input->evbit);
> >  			switch(usage->hid & HID_USAGE) {
> > +				case 0x000: map_key_clear(KEY_TV);
> >  				/* Reported on Logitech Ultra X Media Remote */
> >  				case 0x004: map_key_clear(KEY_AGAIN);		break;
> >  				case 0x00d: map_key_clear(KEY_HOME);		break;
> > @@ -1039,6 +1040,28 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
> >  		return;
> >  	}
> >  
> > +	/* "Sleep" key */
> > +	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
> > +			((usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK) &&
> > +			((usage->hid & 0xf0) == 0x80)  &&
> > +			((usage->hid & 0xf) == 0x2)) {
> > +		input_event(input, usage->type, usage->code, 1);
> > +		input_sync(input);
> > +		input_event(input, usage->type, usage->code, 0);
> > +		input_sync(input);
> > +		return;
> > +	}
> > +	/* "TV" key */
> > +	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
> > +			((usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR) &&
> > +			((usage->hid & HID_USAGE) == 0x0000)) {
> > +		input_event(input, usage->type, usage->code, 1);
> > +		input_sync(input);
> > +		input_event(input, usage->type, usage->code, 0);
> > +		input_sync(input);
> > +		return;
> > +	}
> > +
> >  	/* Handling MS keyboards special buttons */
> >  	if (IS_MS_KB(hid) && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
> >  		int key = 0;
> > It was working fine.
> 
> Hi,
> 
> The patch didn't add complete support for this device, there still has 
> been problem with "TV" key, and I have asked Adolfo to perform a test with 
> debugging patch, but there seems to be no response so far [1]

For me, as I mentionned, there are 6 keys not working with or without
the patch (home, tv, photo, movies, music, and another key for which I
do not have a description), in addition to the power key repeating for
ever once pressed.

> Adolfo (added to CC), has there been any progress, so that we could 
> proceed with merging the patch adding proper support for this HW?

I could also help debugging/testing.

Phil.
