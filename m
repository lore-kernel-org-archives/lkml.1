Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbYJ0M6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbYJ0M6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYJ0M6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:58:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:55350 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYJ0M6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:58:30 -0400
Message-ID: <ac3eb2510810270558u52a66aefqe8774c09ffb19296@mail.gmail.com>
Date: Mon, 27 Oct 2008 13:58:28 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Thomas Renninger" <trenn@suse.de>
Subject: Re: leds-hp-disk vs lis3lv02d
Cc: "Pavel Machek" <pavel@suse.cz>, "Eric Piel" <eric.piel@tremplin-utc.net>,
       akpm@linux-foundation.org, burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, "Len Brown" <len.brown@intel.com>,
       "Kay Sievers" <kasievers@suse.de>, hmh@hmh.eng.br
In-Reply-To: <200810271345.04961.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org>
	 <4902F817.4050108@tremplin-utc.net> <20081026174023.GA1847@ucw.cz>
	 <200810271345.04961.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 13:45, Thomas Renninger <trenn@suse.de> wrote:
> On Sunday 26 October 2008 18:40:25 Pavel Machek wrote:

>> > How can I tell to ACPI that it should load both drivers for the same PNP
>> > ID match?
>>
>> I'll take a look if I can figure something out...
> Kay may know whether this should work and how.
> IMO having several drivers registering for the same HID should get avoided if
> possible, it's confusing.

There is currently no driver core support to bind two "struct device"
to one parent "struct device" from different drivers.

You can work around that by creating a custom "struct bus_type",
create the several function devices there, and let them bind different
drivers. This is what matches a lot of hardware like custom devices
all hiding behind a single PCI device.

Or the code for the two functions must live in the same driver, and
create class devices, so it looks to the core like a single binding.

There is ongoing work in the driver core to allow
multi-driver-binding, but it's not ready to use today.

Kay
