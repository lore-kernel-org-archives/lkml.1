Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXCEW13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXCEW13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXCEW13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:27:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50673 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbXCEW12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HVXggwYAAzVAUY6Mi9xFqmb8/tUVZkF3vTmBNBldiXjEmN8De3WCyc2l0M5BmUd0YW2jG+XO435VN3l/FytCZtK9H88bslHuOM0xue5PfoAsGvZJjAAMPgS3LSVT9Tp01iLmDAYM3+C+NS8bvZhsJ7VXGmr0sBJp5jAwd6P1ZYQ=
Message-ID: <d120d5000703051427r577acc82x85a70ff963b991fa@mail.gmail.com>
Date: Mon, 5 Mar 2007 17:27:24 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver Interface 0.5.0
Cc: "Li Yu" <raise.sail@gmail.com>, "Greg Kroah Hartman" <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Vincent Legoll" <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Harold Sargeant" <harold-sargeant@ntlworld.com>
In-Reply-To: <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com>
	 <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Mon, 5 Mar 2007, Li Yu wrote:
>
> >  Under standard HID device driver development means, we need to write
> > one interrupt handler for each new HID device to report event to input
> > subsystem. However, although the most of they can not merge into
> > mainstream kernel tree, they have only some extended keys, e.g. many
> > remote controllers. I think it seem break a fly on the wheel, which
> > write one new interrupt handler for this reason.
>
> This paragraph I don't seem to understand. Either the device is claimed by
> hid-input (*), and then when the device is behaving more-or-less
> correctly, hid-input handles the usages sent in reports and maps them
> properly to input events. New mapping can be quite trivially added to
> hid-input.
>

We are running out if quirks and we can't continue in this fashion so
Li tried to provide mechanism to augment default HID behaviour for
sepcific devices. However I don't think we want this particular
implementation - it firrces sub-drivers to be compiled into HID driver
which may grow indefinitely.

If we define HID "bus" allowing drivers to bind on VID:PID and provide
default library module for parsing HID reports and providing access to
HID transports (USB/BT) then writing tiny drivers adjusting just a
part of hid_input_event and relying on default implemenattaion where
it makes sense will become a breeze.

-- 
Dmitry
