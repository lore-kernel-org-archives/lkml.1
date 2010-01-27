Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468Ab0A0O5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0A0O5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432Ab0A0O5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:57:52 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:44511 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0A0O5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:57:52 -0500
Message-ID: <fd35fcc83b1a4ae5dd4daba3cf596c5d.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <alpine.LRH.2.00.1001270018570.15694@twin.jikos.cz>
References: <3026aa4769d53c108ee0671f2b17c668.squirrel@intranet.cs.nmsu.edu>
    <alpine.LRH.2.00.1001270018570.15694@twin.jikos.cz>
Date: Wed, 27 Jan 2010 07:57:48 -0700
Subject: Re: usbhid driver: replacing resume or using a post resume function
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Linux" <linux-kernel@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 26 Jan 2010, Rick L. Vinyard, Jr. wrote:
>
>> I was looking for an example of a hid driver that needs to customize
>> resume or provides a post resume function, but couldn't find one.
>>
>> I would like to implement some post resume code. In particular, the g13
>> on
>> resume loses the backlight color, LCD image and LED state. On resume, it
>> needs feature reports sent to re-establish these settings.
>>
>> However, I couldn't find a way to either provide a post resume function
>> or
>> replace resume with a call to hid_resume() followed by the feature
>> reports.
>>
>> Any suggestions?
>
> Current HID / USBHID code doesn't allow for that. But implementing that
> should be pretty straightforward, you can define callbacks in the
> hid_device struct and then redirect to them instead of the default ones,
> when they are initialized.

Sounds good. I was actually thinking of doing a post_reset() and
post_resume().

I think the most common case would be for something like the G13 to
re-establish settings, which from the few devices I'm familiar with would
need to restart the hid subsystem first and then re-establish through
feature reports, et. al. after the hid_resume().

Also, that means that usbhid's hid_resume() doesn't need to be exposed in
the API, or even need to be usb specific.

>
> If you submit this patch together (but separately) with your Logitech G13
> driver, there shouldn't be any obstacle merging it.
>

Sounds good.

Thanks,

Rick

